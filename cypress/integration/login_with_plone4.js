describe("Login Plone 4 with WCA", () => {
  it("Visits Plone 4 site", () => {
    cy.visit("http://plone4.localhost");
    cy.contains("Welcome to Plone").click();
    cy.contains("Log in").click();
    cy.contains("Je suis un agent").click();
    cy.get("input[name=username]").type("jdoe");
    cy.get("select").then(($element) => {
      $element.val("2");
    });
    cy.get("input[name=password]").type(`jdoe{enter}`);
    cy.get("button[name=accept]").click();
    cy.contains("You are now logged in");
    cy.contains("John Doe").click();
    cy.contains("Log out").click();
  });
});
