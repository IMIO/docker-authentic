describe("Login Plone 5 with WCA", () => {
  // const username = 'jdoe'
  // const password = 'jdoe'

  // Cypress.Commands.add('loginByCSRF', (csrfToken) => {
  //   cy.request({
  //     method: 'POST',
  //     url: '/login',
  //     failOnStatusCode: false, // dont fail so we can make assertions
  //     form: true, // we are submitting a regular form body
  //     body: {
  //       username,
  //       password,
  //       _csrf: csrfToken, // insert this as part of form body
  //     },
  //   })
  // })
  // Cypress.Cookies.debug(true)
  // it('strategy #1: parse token from HTML', function () {
  //   // if we cannot change our server code to make it easier
  //   // to parse out the CSRF token, we can simply use cy.request
  //   // to fetch the login page, and then parse the HTML contents
  //   // to find the CSRF token embedded in the page
  //   cy.request('/login')
  //   .its('body')
  //   .then((body) => {
  //     // we can use Cypress.$ to parse the string body
  //     // thus enabling us to query into it easily
  //     const $html = Cypress.$(body)
  //     const csrf = $html.find('input[name=csrfmiddlewaretoken]').val()

  //     cy.loginByCSRF(csrf)
  //     .then((resp) => {
  //       expect(resp.status).to.eq(200)
  //       // expect(resp.body).to.include('<h2>dashboard.html</h2>')
  //     })
  //   })
  // });

  it("Visits Plone 5 site", () => {
    cy.viewport(1200, 850)
    cy.visit("http://plone5.localhost");
    cy.contains("Welcome!").click();
    cy.contains("Log in").click();
    cy.contains("Je suis un agent").click();
    // cy.origin("")
    cy.origin('http://agents.wc.localhost', () => {
      cy.get("input[name=username]").type("jdoe");
      cy.get("select").then(($element) => {
        $element.val("2");
      });
      // cy.get("input[name=password]").type(`jdoe{enter}`);
      cy.get("input[name=password]").type(`jdoe`);

      cy.get("input[name=login-password-submit]").click()
    });
    // const csrf = cy.get('input[name=csrfmiddlewaretoken]').val
    // cy.get("input[name=username]").type(csrf);
    // cy.get('form').submit()

    // cy.get("button[name=input]").click();
    cy.contains("Logged in with");
    //cy.get("#portal-personaltools").click();
    cy.get("#personaltools-logout").click({ force: true });
    cy.contains("Welcome to Plone");
  });
});
