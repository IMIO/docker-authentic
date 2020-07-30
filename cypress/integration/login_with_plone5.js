describe("Login Plone 5 with WCA", () => {
  it("Visits Plone 5 site", () => {
    Cypress.Cookies.debug(true);
    cy.visit("http://plone5.localhost");
    cy.contains("Welcome!").click();
    cy.contains("Log in").click();
    cy.contains("Je suis un agent").click();
    cy.get("input[name=username]").type("jdoe");
    cy.get("select").then(($element) => {
      $element.val("2");
    });
    cy.get("input[name=password]").type(`jdoe{enter}`);
    cy.get("button[name=accept]").click();
    cy.contains("Logged in with");
    //cy.get("#portal-personaltools").click();
    cy.get("#personaltools-logout").click({ force: true });
    cy.contains("Welcome to Plone");
  });
});
