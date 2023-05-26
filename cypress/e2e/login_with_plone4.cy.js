describe("Login Plone 4 with WCA", () => {
  beforeEach(() => {
    Cypress.Cookies.debug(true)
    // cy.visit('https://example.cypress.io/commands/cookies')
    // clear cookies again after visiting to remove
    // any 3rd party cookies picked up such as cloudflare
    // cy.clearCookies()
  })
  it("Visits Plone 4 site", () => {
    cy.visit("http://plone4.traefik.me");
    cy.contains("Welcome to Plone").click();
    cy.contains("Log in").click();
    cy.contains("Je suis un agent").click();
    cy.origin('http://agents.traefik.me', () => {
      cy.get("input[name=username]").type("jdoe");
      // cy.debug
      cy.get("select").then(($element) => {
        $element.val("2");
      });
      // cy.get("input[name=password]").type(`jdoe{enter}`);
      // cy.request({headers: { 'access-control-allow-origin': '*', 'csrf_processing_done': true },})
      cy.get("input[name=password]").type(`jdoe`);
      cy.get('input[name=login-password-submit]').click();
    // cy.debug()
    // Cypress.Cookies.debug(true);
    // cy.setCookie("authomatic", "temp");
    // cy.get("button[name=accept]").click();
    });
    cy.contains("Logged in with");
    cy.contains("John Doe").click();
    cy.contains("Log out").click();
  });
});
