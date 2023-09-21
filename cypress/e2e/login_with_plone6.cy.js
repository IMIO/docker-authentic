describe("Login Plone 6 with Waco Agents", () => {

  it("Visits Plone 6 site", () => {
    cy.viewport(1200, 850)
    cy.visit("https://plone6.dev.publik.love");
    cy.contains("Plone");
    cy.contains("Se connecter").click();
    cy.contains("Je suis un agent").click();
    // cy.origin('https://agents.dev.publik.love', () => {
      cy.get("input[name=username]").type("jdoe");
      cy.get("select").then(($element) => {
        $element.val("2");
      });
      // cy.get("input[name=password]").type(`jdoe{enter}`);
      cy.get("input[name=password]").type(`jdoe`);
      cy.get("input[name=login-password-submit]").click()
    // });
    cy.contains("Logged in with");
    cy.get("#personaltools-logout").click({ force: true });
    cy.contains("Welcome to Plone");
  });
});
