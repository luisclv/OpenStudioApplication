function Component()
{
  Component.prototype.createOperations = function()
  {
    // call default implementation
    component.createOperations();

    // ... add custom operations

    var kernel = systemInfo.kernelType;
    if( kernel == "darwin" ) {

      console.log("This is component " + component.name + ", display " + component.displayName + ", installed=" + component.installed);

      // This is equivalent to mkdir -p, will make any directory in between, no
      // override if it exists already
      component.addElevatedOperation("Mkdir", "@TargetDir@/OpenStudioApp.app/Contents/");

      // Copies the content of ./EnergyPlus/* into /OpenStudioApp.app/Contents/Resources/*
      // Be VERY mindful of the trailing slashes... This behaves very weirdly
      // Source doesn't not include trailing, so it's the directory itself
      // Target does include trailing, so it's within that directory
      component.addElevatedOperation("CopyDirectory", "@TargetDir@/EnergyPlus", "@TargetDir@/OpenStudioApp.app/Contents/");
      component.addElevatedOperation("CopyDirectory", "@TargetDir@/Radiance", "@TargetDir@/OpenStudioApp.app/Contents/");

      // an equivalent is
      // component.addOperation("Mkdir", "@TargetDir@/OpenStudioApp.app/Contents/EnergyPlus")
      // component.addOperation("CopyDirectory", "@TargetDir@/EnergyPlus/", "@TargetDir@/OpenStudioApp.app/Contents/EnergyPlus/")

      var linktarget = "@TargetDir@/OpenStudioApp.app/Contents/Frameworks/QtWebEngineCore.framework/Versions/5/Helpers/QtWebEngineProcess.app/Contents/Frameworks";
      var linksource = "../../../../../../../Frameworks";
      component.addElevatedOperation("Execute", "ln", "-s", linksource, linktarget);
    }

    if( kernel == "winnt" ) {
      component.addElevatedOperation("CreateShortcut", "@TargetDir@/bin/OpenStudioApp.exe", "@StartMenuDir@/OpenStudio.lnk");
      // Note JM: you have to quote the %1 which represents the file path, otherwise any space in the path will think there are multiple args
      component.addElevatedOperation("RegisterFileType", "osm", "@TargetDir@/bin/OpenStudioApp.exe \"%1\"", "OpenStudio Model File", "text/plain", "@TargetDir@/bin/OpenStudioApp.exe,1");
    }
  }
}



