-- Custom Factions: fraktionsneutrale Umrechnung von Bauvorlagen.
-- Hook auf /lua/ui/game/construction.lua (Spiel-UI). Ersetzt OnSelection durch LOUDs Fassung
-- (LOUD lua.scd, lua/ui/game/construction.lua Z. 3005-3351, Stand 2026-10-22) mit EINER Aenderung:
-- die Praefix-Tabelle in ConvertID wird um alle Fraktionen mit Feld 'BuildingPrefixes' im
-- Fraktionseintrag (factions.lua) ergaenzt; eine Fraktion ohne Praefixe liefert 'nicht umrechenbar'
-- statt eines Lua-Fehlers. Bei LOUD-Updates gegen das Original abgleichen.
-- Der Hook laeuft in der Umgebung von construction.lua und nutzt deren Locals.

function OnSelection(buildableCategories, selection, isOldSelection)

    if table.empty(selection) then
        allFactories = false
    else    
        allFactories = true
        
        for i,v in selection do
            if not v:IsInCategory('FACTORY') then
                allFactories = false
                break
            end
        end
    end    

    if table.getsize(selection) > 0 then

        capturingKeys = false

        -- Sorting down units - get all the units
        local buildableUnits = EntityCategoryGetUnitList(buildableCategories)

        if not isOldSelection then
            previousTabSet = nil
            previousTabSize = nil
            activeTab = nil
            ClearSessionExtraSelectList()
        end

        sortedOptions = {}
        UnitViewDetail.Hide()

		-- this is where the category CONSTRUCTIONSORTDOWN comes into play
		-- it's intended to have an item appear one tier down from it's TECH level
		-- this is useful for factories - since they appear as upgrades - but not
		-- so good for engineers as the higher tier unit appears one tier down - can't think of which way to go here
		-- if I knew what kind of unit was doing the selection, I could code around it - let's try this

		-- default this behavior to off
		local do_sortdown = false

		-- turn it on for factories
		for _, v in selection do
			if v:IsInCategory('FACTORY') then
				do_sortdown = true
				break
			end
		end

		local sortDowns = false

		if do_sortdown then
			sortDowns = EntityCategoryFilterDown(categories.CONSTRUCTIONSORTDOWN, buildableUnits)
		end

		-- modded to function if no units have the CONSTRUCTIONSORTDOWN category or have it behave differently between engineers and factories if they do
		if sortDowns then
			sortedOptions.t1 = EntityCategoryFilterDown(categories.TECH1 - categories.CONSTRUCTIONSORTDOWN, buildableUnits)
			sortedOptions.t2 = EntityCategoryFilterDown(categories.TECH2 - categories.CONSTRUCTIONSORTDOWN, buildableUnits)
			sortedOptions.t3 = EntityCategoryFilterDown(categories.TECH3 - categories.CONSTRUCTIONSORTDOWN, buildableUnits)
			sortedOptions.t4 = EntityCategoryFilterDown(categories.EXPERIMENTAL - categories.CONSTRUCTIONSORTDOWN, buildableUnits)

			-- now add the CONSTRUCTIONSORTDOWN units to the tier below
			for _, unit in sortDowns do
				if EntityCategoryContains(categories.EXPERIMENTAL, unit) then
					LOUDINSERT(sortedOptions.t3, unit)
				elseif EntityCategoryContains(categories.TECH3, unit) then
					LOUDINSERT(sortedOptions.t2, unit)
				elseif EntityCategoryContains(categories.TECH2, unit) then
					LOUDINSERT(sortedOptions.t1, unit)
				end
			end
		else
			-- if an engineer or no CONSTRUCTIONSORTDOWN categories
			sortedOptions.t1 = EntityCategoryFilterDown(categories.TECH1, buildableUnits)
			sortedOptions.t2 = EntityCategoryFilterDown(categories.TECH2, buildableUnits)
			sortedOptions.t3 = EntityCategoryFilterDown(categories.TECH3, buildableUnits)
			sortedOptions.t4 = EntityCategoryFilterDown(categories.EXPERIMENTAL, buildableUnits)
		end

        if buildableUnits[1] then
        
            controls.constructionTab:Enable()
            
        else
        
            controls.constructionTab:Disable()
            
            if BuildMode.IsInBuildMode() then
                BuildMode.ToggleBuildMode()    
            end
            
        end

        sortedOptions.selection = selection
        controls.selectionTab:Enable()

        local allSameUnit = true
        local bpID = false
        local allMobile = true

		-- decide if all mobile, all same unit, and bpID if it is
        for i, v in selection do

            if allMobile and not v:IsInCategory('MOBILE') then

                allMobile = false
            end

            if allSameUnit and bpID and bpID != v:GetBlueprint().BlueprintId then

                allSameUnit = false

            else

                bpID = v:GetBlueprint().BlueprintId
            end

            if not allMobile and not allSameUnit then
                break
            end
        end

        -- turn on enhancement tab if it has enhancement and all same unit
		-- this permits multiple units to enhance at once
		if selection[1]:GetBlueprint().Enhancements and allSameUnit then

            controls.enhancementTab:Enable()

        else

            controls.enhancementTab:Disable()
        end

		-- see if there are any building templates
        local templates = Templates.GetTemplates()

        if allMobile and templates and table.getsize(templates) > 0 then

            sortedOptions.templates = {}

            for templateIndex, template in templates do

                local valid = true

                for _, entry in template.templateData do
                    if type(entry) == 'table' then
                        if not table.find(buildableUnits, entry[1]) then
                            valid = false
                            break
                        end
                    end
                end

                if valid then
                    template.templateID = templateIndex
                    LOUDINSERT(sortedOptions.templates, template)
                end
            end
        end

        if LOUDGETN(selection) == 1 then

            currentCommandQueue = SetCurrentFactoryForQueueDisplay(selection[1])

        else
            currentCommandQueue = {}
            ClearCurrentFactoryForQueueDisplay()
        end

		-- Allow all races to build other races templates
		-- by trying to replace unit prefixes - doesn't handle
		-- much but the stock units
        local buildableUnits = EntityCategoryGetUnitList(buildableCategories)

        if allMobile and templates and table.getsize(templates) > 0 then

			local currentFaction = selection[1]:GetBlueprint().General.FactionName

			if currentFaction then

	            sortedOptions.templates = {}

				local function ConvertID(BPID)

					local prefixes = {
                        ["AEON"] = {"uab","xab","dab","bab","sab"},
                        ["UEF"] = {"ueb","xeb","deb","beb","seb"},
						["CYBRAN"] = {"urb","xrb","drb","brb","srb"},
						["SERAPHIM"] = {"xsb","usb","dsb","bsb","ssb"},
					}

					-- Custom Factions: Praefixe weiterer Fraktionen aus factions.lua (Feld BuildingPrefixes)
					for _, fdata in import('/lua/factions.lua').Factions do
						local fkey = string.upper(fdata.Category or fdata.Key or '')
						if fdata.BuildingPrefixes and not prefixes[fkey] then
							prefixes[fkey] = fdata.BuildingPrefixes
						end
					end

					-- Custom Factions: Fraktion ohne Praefixe -> nicht umrechenbar statt Lua-Fehler
					if not prefixes[string.upper(currentFaction)] then
						return false
					end

					for i, prefix in prefixes[string.upper(currentFaction)] do

						if table.find(buildableUnits, string.gsub(BPID, "(%a+)(%d+)", prefix .. "%2")) then

							return string.gsub(BPID, "(%a+)(%d+)", prefix .. "%2")

						end
					end

					return false

				end

	            for templateIndex, template in templates do

	                local valid = true
					local converted = false

	                for _, entry in template.templateData do

	                    if type(entry) == 'table' then

	                        if not table.find(buildableUnits, entry[1]) then

								entry[1] = ConvertID(entry[1])

								converted = true

		                        if not table.find(buildableUnits, entry[1]) then
									valid = false
		                            break
								end
	                        end
	                    end
	                end

	                if valid then

						if converted then
							template.icon = ConvertID(template.icon)
	                    end

						template.templateID = templateIndex

	                    table.insert(sortedOptions.templates, template)

					end
                end
            end
		end

		--refresh the construction tab to show any new available templates
		if not isOldSelection then

            if not controls.constructionTab:IsDisabled() then
                controls.constructionTab:SetCheck(true)
            else
                controls.selectionTab:SetCheck(true)
            end

        elseif controls.constructionTab:IsChecked() then

            controls.constructionTab:SetCheck(true)

        elseif controls.enhancementTab:IsChecked() then

            controls.enhancementTab:SetCheck(true)

        else

            controls.selectionTab:SetCheck(true)

        end

		prevSelection = selection
		prevBuildCategories = buildableCategories
		prevBuildables = buildableUnits
		import(UIUtil.GetLayoutFilename('construction')).OnSelection(false)

		controls.constructionGroup:Show()
		controls.choices:CalcVisible()
		controls.secondaryChoices:CalcVisible()

    else

        if BuildMode.IsInBuildMode() then
            BuildMode.ToggleBuildMode()
        end

        currentCommandQueue = {}
        ClearCurrentFactoryForQueueDisplay()
        import(UIUtil.GetLayoutFilename('construction')).OnSelection(true)

	end

    if allFactories then

        sortedOptions.templates = {}

        local templates = TemplatesFactory.GetTemplates()

        if templates and not table.empty(templates) then

            local buildableUnits = EntityCategoryGetUnitList(buildableCategories)

            for templateIndex, template in ipairs(templates) do

                local valid = true

                for index, entry in ipairs(template.templateData) do

                    if not table.find(buildableUnits, entry.id) then
                        
                        valid = false

                        -- allow templates containing factory upgrades & higher tech units
                        if index > 1 then
                            
                            for i = index - 1, 1, -1 do
                                
                                local blueprint = __blueprints[template.templateData[i].id]

                                if blueprint.General.UpgradesFrom ~= 'none' then
                                    -- previous entry is a (valid) upgrade
                                    valid = true
                                    break
                                end
                            end
                        end

                        break
                    end
                end

                if valid then
                    template.templateID = templateIndex
                    table.insert(sortedOptions.templates, template)
                end
            end
        end

        -- templates tab enable & refresh
        local templatesTab = GetTabByID('templates')

        if templatesTab then
               
            templatesTab:Enable()

            if templatesTab:IsChecked() then
                templatesTab:SetCheck(true)
            end
        end
    end    

end

