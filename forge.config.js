module.exports = {
  packagerConfig: {
    icon: 'images/quant-icon.ico'
  },
  rebuildConfig: {},
  makers: [
    {
      name: '@electron-forge/maker-squirrel',
      config: {
        loadingGif: 'shiny/www/quant-spinner-smooth.gif',
        icon: 'images/quant-icon.ico',
        setupIcon: 'images/quant-icon-setup.ico'
      },
    }
  ],
  publishers: [
    {
      name: '@electron-forge/publisher-github',
      config: {
        repository: {
          owner: 'lsteinmann',
          name: 'milQuant-dist'
        },
        prerelease: false,
        draft: true
      }
    }
  ],
  hooks: {
    postPackage: async (forgeConfig, options) => {
      console.info('Packages built at:', options.outputPaths);
    }
  }
};
