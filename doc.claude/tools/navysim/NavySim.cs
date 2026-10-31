// Gefechtssimulation U-Boot-Gruppen (LOUD), siehe README.md in diesem Ordner.
// Modell: zwei Gruppen als Punkte auf einer Linie, Anfahrt bis zur eigenen Reichweite, Torpedos als Flugkoerper
// mit Beschleunigung, Abwehrfelder (MissileTorpDestroy) und Abwehrwerfer (Anti-Torpedo-Waffen). Takt 0,1 s.
using System;
using System.Collections.Generic;
using System.Linq;

public class UnitType {
    public string Name; public double Hp, Regen, Speed, Mass, Range;
    public double Damage; public int Salvo; public double SalvoDelay, Cycle;
    public double V0, Accel, VMax, Lifetime;
    public int Fields; public double FieldCooldown, FieldRadius = 3.2;
    public double[] Launchers = new double[0]; public double LauncherMin = 6, LauncherMax = 28;
}

class Torp { public Unit Target; public int Side; public double Dist, V, Age, Damage; public bool Dead; }

class Unit {
    public UnitType T; public double Hp; public bool Alive = true; public Unit Target;
    public double NextSalvo; public int ShotsLeft; public double NextShot;
    public double[] FieldReady; public double[] LauncherReady;
}

public class Result {
    public bool AWins, Draw; public int ASurv, BSurv; public double AHpFrac, BHpFrac, Time;
    public double AMassLost, BMassLost; public int BDeadBeforeBFirstShot; public double AFirstShot, BFirstShot;
}

public static class NavySim {
    public static Result Run(UnitType ta, int na, UnitType tb, int nb, double pHit, int seed, double startDist = 90, double maxTime = 600) {
        var rnd = new Random(seed);
        var side = new List<Unit>[2];
        side[0] = Enumerable.Range(0, na).Select(i => Make(ta)).ToList();
        side[1] = Enumerable.Range(0, nb).Select(i => Make(tb)).ToList();
        var types = new[] { ta, tb };
        var torps = new List<Torp>();
        double d = startDist, t = 0, dt = 0.1;
        double[] firstShot = { -1, -1 };
        int bDeadAtBFirst = -1;
        while (t < maxTime) {
            bool[] moving = new bool[2];
            for (int s = 0; s < 2; s++) moving[s] = side[s].Any(u => u.Alive) && d > types[s].Range;
            if (!side[0].Any(u => u.Alive) || !side[1].Any(u => u.Alive)) break;
            // Bewegung
            double close = 0;
            for (int s = 0; s < 2; s++) if (moving[s]) close += types[s].Speed * dt;
            d = Math.Max(0, d - close);
            // Feuern
            for (int s = 0; s < 2; s++) {
                if (d > types[s].Range) continue;
                var enemies = side[1 - s].Where(u => u.Alive).ToList();
                if (enemies.Count == 0) continue;
                foreach (var u in side[s]) {
                    if (!u.Alive) continue;
                    if (u.ShotsLeft == 0 && t >= u.NextSalvo) { u.ShotsLeft = u.T.Salvo; u.NextShot = t; u.NextSalvo = t + u.T.Cycle; }
                    while (u.ShotsLeft > 0 && t >= u.NextShot - 1e-9) {
                        if (u.Target == null || !u.Target.Alive) u.Target = enemies[rnd.Next(enemies.Count)];
                        torps.Add(new Torp { Target = u.Target, Side = s, Dist = d, V = u.T.V0, Damage = u.T.Damage });
                        if (firstShot[s] < 0) {
                            firstShot[s] = t;
                            if (s == 1) bDeadAtBFirst = side[1].Count(x => !x.Alive);
                        }
                        u.ShotsLeft--; u.NextShot += u.T.SalvoDelay;
                    }
                }
            }
            // Abwehrwerfer: beliebiger anfliegender Torpedo auf die eigene Seite im Fenster
            for (int s = 0; s < 2; s++) {
                foreach (var u in side[s]) {
                    if (!u.Alive) continue;
                    for (int l = 0; l < u.LauncherReady.Length; l++) {
                        if (t < u.LauncherReady[l]) continue;
                        var tp = torps.FirstOrDefault(x => !x.Dead && x.Side != s && x.Dist <= u.T.LauncherMax && x.Dist >= u.T.LauncherMin);
                        if (tp == null) continue;
                        u.LauncherReady[l] = t + u.T.Launchers[l];
                        if (rnd.NextDouble() < pHit) tp.Dead = true;
                    }
                }
            }
            // Torpedos fliegen
            foreach (var tp in torps) {
                if (tp.Dead) continue;
                var ttype = types[1 - tp.Side];
                var shooterType = types[tp.Side];
                tp.V = Math.Min(shooterType.VMax, tp.V + shooterType.Accel * dt);
                tp.Dist -= tp.V * dt + (moving[1 - tp.Side] ? ttype.Speed * dt : 0);
                tp.Age += dt;
                if (tp.Age > shooterType.Lifetime) { tp.Dead = true; continue; }
                var tg = tp.Target;
                if (tg.Alive && tp.Dist <= ttype.FieldRadius) {
                    for (int f = 0; f < tg.FieldReady.Length; f++)
                        if (t >= tg.FieldReady[f]) { tg.FieldReady[f] = t + ttype.FieldCooldown; tp.Dead = true; break; }
                    if (tp.Dead) continue;
                }
                if (tp.Dist <= 0) {
                    tp.Dead = true;
                    if (tg.Alive) { tg.Hp -= tp.Damage; if (tg.Hp <= 0) { tg.Alive = false; } }
                }
            }
            torps.RemoveAll(x => x.Dead);
            // Regeneration
            for (int s = 0; s < 2; s++) foreach (var u in side[s]) if (u.Alive) u.Hp = Math.Min(u.T.Hp, u.Hp + u.T.Regen * dt);
            t += dt;
        }
        var r = new Result();
        int aAlive = side[0].Count(u => u.Alive), bAlive = side[1].Count(u => u.Alive);
        r.ASurv = aAlive; r.BSurv = bAlive; r.Time = t;
        r.AWins = aAlive > 0 && bAlive == 0; r.Draw = (aAlive > 0 && bAlive > 0) || (aAlive == 0 && bAlive == 0);
        r.AHpFrac = side[0].Where(u => u.Alive).Sum(u => u.Hp) / (na * ta.Hp);
        r.BHpFrac = side[1].Where(u => u.Alive).Sum(u => u.Hp) / (nb * tb.Hp);
        r.AMassLost = (na - aAlive) * ta.Mass; r.BMassLost = (nb - bAlive) * tb.Mass;
        r.BDeadBeforeBFirstShot = bDeadAtBFirst < 0 ? nb - bAlive : bDeadAtBFirst;
        r.AFirstShot = firstShot[0]; r.BFirstShot = firstShot[1];
        return r;
    }

    static Unit Make(UnitType t) {
        return new Unit { T = t, Hp = t.Hp, FieldReady = new double[t.Fields], LauncherReady = new double[t.Launchers.Length] };
    }
}
