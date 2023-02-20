module.exports = {
  packagerConfig: {
    icon: 'quant-icon.ico' // no file extension required
  },
  rebuildConfig: {},
  makers: [
    {
      name: '@electron-forge/maker-squirrel',
      config: {
        loadingGif: './www/quant-spinner-smooth.gif',
        icon: './quant-icon.ico',
        setupIcon: './quant-icon-setup.ico'
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
