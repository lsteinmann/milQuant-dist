module.exports = {
  packagerConfig: {
    icon: 'quant-icon.ico' // no file extension required
  },
  rebuildConfig: {},
  makers: [
    {
      name: '@electron-forge/maker-squirrel',
      config: {},
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
