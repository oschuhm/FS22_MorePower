--
-- More Power for LS 22
--
-- # Author: LS-Farmers
-- # GitHub: https://github.com/oschuhm/FS22_MorePower
-- # date:   02.01.2023
--

morePower = {}
morePower.MOD_NAME = g_currentModName

function morePower.prerequisitesPresent(specializations)
  return true
end

function morePower.registerEventListeners(vehicleType)
  SpecializationUtil.registerEventListener(vehicleType, "onPreLoad", morePower)
end

function morePower:onPreLoad()
  --print ("DEBUG: morePower onPreLoad")
  if self.loadMotor ~= nil then
    --print ("DEBUG: morePower overwrite function")
    self.loadMotor = Utils.overwrittenFunction(self.loadMotor, morePower.loadMotor)
  end
end

function morePower:loadMotor(superFunc, xmlFile, motorId)
  --print ("DEBUG: Called loadMotor")
  --DebugUtil.printTableRecursively(xmlFile,'xmlBefore .. ',1,3)
  local key = nil
  local fallbackConfigKey = "vehicle.motorized.motorConfigurations.motorConfiguration(0)"

  key, motorId = ConfigurationUtil.getXMLConfigurationKey(xmlFile, motorId, "vehicle.motorized.motorConfigurations.motorConfiguration", "vehicle.motorized", "motor")
  morePower.torqueScaleBefore = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor", "#torqueScale", 1, fallbackConfigKey)

  --print ("DEBUG: key: " .. key)
  --print ("DEBUG: motorId: " .. motorId)

  --print ("DEBUG: morePower.torqueScaleBefore: " .. morePower.torqueScaleBefore)

  xmlFile:setFloat(key .. ".motor" .. "#torqueScale", morePower.torqueScaleBefore * 2)

  morePower.torqueScaleAfter = ConfigurationUtil.getConfigurationValue(xmlFile, key, ".motor", "#torqueScale", 1, fallbackConfigKey)
  --print ("DEBUG: morePower.torqueScaleAfter: " .. morePower.torqueScaleAfter)

  superFunc(self, xmlFile, motorId)
end

