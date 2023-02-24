const { Menu, app, dialog } = require('electron')




const template = [
    {
        label: 'milQuant',
        submenu: [
            {
                label: 'Reload',
                accelerator: 'CmdOrCtrl+R',
                click(item, focusedWindow) {
                    if (focusedWindow) focusedWindow.reload()
                }
            },
            {
                role: 'togglefullscreen'
            },
            {
                type: 'separator'
            },
            {
                role: 'copy'
            },
            {
                role: 'paste'
            },
            {
                role: 'selectall'
            },
            {
                type: 'separator'
            },
            {
                role: 'minimize'
            },
            {
                role: 'close'
            }
        ]
    },
    {
        role: 'help',
        submenu: [
            {
                label: 'milQuant on GitHub',
                click: async () => {
                    const { shell } = require('electron')
                    await shell.openExternal('https://github.com/lsteinmann/milQuant-dist')
                }
            },
            {
                label: 'Miletus Excavation',
                click: async () => {
                    const { shell } = require('electron')
                    await shell.openExternal('https://www.miletgrabung.uni-hamburg.de/')
                }
            },
            {
                type: 'separator'
            },
            {
                label: 'Toggle Developer Tools',
                click(item, focusedWindow) {
                    if (focusedWindow) focusedWindow.webContents.toggleDevTools()
                }
            },
            {
                type: 'separator'
            },
            {
                label: 'About',
                click: function showAbout() {
                    dialog.showMessageBox({
                        title: `About ${app.getName()}`,
                        message:`${app.getName()} ${app.getVersion()}`,
                        detail: 'Solange man lebt soll man ... zählen.',
                        buttons: [],
                        icon: `${app.getAppPath()}/images/quant-icon-tiny.png`
                    });
                }
            },
        ]
    }
]


const menu = Menu.buildFromTemplate(template)
Menu.setApplicationMenu(menu)
