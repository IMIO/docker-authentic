module.exports = {
  chromeWebSecurity: false,
  e2e: {
    baseUrl: 'http://agents.wc.localhost',
    // specPattern: '**/*.cy.js',
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
  },
};