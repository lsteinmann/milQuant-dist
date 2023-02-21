module.exports = {
  packagerConfig: {
    icon: 'images/quant-icon.ico'
  },
  rebuildConfig: {},
  makers: [
    {
      name: '@electron-forge/maker-squirrel',
      // https://js.electronforge.io/interfaces/_electron_forge_maker_squirrel.InternalOptions.Options.html
      config: {
        setupIcon: 'images/quant-icon.ico'
      },
    },
    {
      name: '@electron-forge/maker-zip'
    },
  ],
  hooks: {
    postPackage: async (forgeConfig, options) => {
      console.info('Packages built at:', options.outputPaths);
    }
  }
};
