QuickOpenDerivedData
====================

Quickly access the Derived Data folder for the application you are working on.

No more going into the Organizer, going to the Projects section, clicking on your project, and then clicking the little arrow to open the folder. 

Not to mention all those time when Xcode doesn't give you a link to the folder. 

Now you are just 1 click away

(Xcode Plugin)


## Installation

- Clone and build the project. The plugin will be installed into `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`. (To uninstall the plugin, delete the `QuickOpenDerivedData.xcplugin` directory from there)
- Restart Xcode
- Select `Quick Open Derived Data in Title Bar` in the `View` menu

### Additional Options

Opening the derived data folder (for the current project/workspace or for all projects) is also available from the `View` menu

## References

- [Creating an Xcode4 Plugin](http://www.blackdogfoundry.com/blog/creating-an-xcode4-plugin/) : Plugin structure and project configuration tutorial
- [MiniXcode](https://github.com/omz/MiniXcode) : Example of how to add UI components to Xcode workspace windows
