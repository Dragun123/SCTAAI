

SCTAFactoryBuilderManager = FactoryBuilderManager
FactoryBuilderManager = Class(SCTAFactoryBuilderManager) {

    GetFactoryFaction = function(self, factory)
        if not self.Brain.SCTAAI then
            return SCTAFactoryBuilderManager.FactoryFinishBuilding(self, factory)
        end
        if EntityCategoryContains(categories.UEF, factory) then
            return 'UEF'
        elseif EntityCategoryContains(categories.AEON, factory) then
            return 'Aeon'
        elseif EntityCategoryContains(categories.CYBRAN, factory) then
            return 'Cybran'
        elseif EntityCategoryContains(categories.SERAPHIM, factory) then
            return 'Seraphim'
        elseif EntityCategoryContains(categories.ARM, factory) then
            return 'Arm'
        elseif EntityCategoryContains(categories.CORE, factory) then
            return 'Core'
        elseif self.Brain.CustomFactions then
            return self:UnitFromCustomFaction(factory)
        end
        return false
    end,

}