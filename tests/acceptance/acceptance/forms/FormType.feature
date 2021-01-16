@symfony-form
Feature: FormType templates

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm errorLevel="1">
        <projectFiles>
          <directory name="."/>
          <ignoreFiles> <directory name="../../vendor"/> </ignoreFiles>
        </projectFiles>

        <plugins>
          <pluginClass class="Psalm\SymfonyPsalmPlugin\Plugin"/>
        </plugins>
      </psalm>
      """
    And I have the following code preamble
      """
      <?php

      class User {}

      use Symfony\Component\Form\AbstractType;
      use Symfony\Component\Form\FormView;
      use Symfony\Component\Form\FormInterface;

      /** @extends AbstractType<User> */
      class UserType extends AbstractType
      {
          public function buildView(FormView $view, FormInterface $form, array $options)
          {
              $user = $form->getData();
              /** @psalm-trace $user */
          }
      }

      """

  Scenario: Asserting arguments return types have inferred (without error) using Definition
    When I run Psalm
    Then I see these errors
      | Type  | Message                   |
      | Trace | $user: User               |
    And I see no other errors
