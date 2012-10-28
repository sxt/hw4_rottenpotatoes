Feature: more stuff to movies

  As a movie buff
  So that I can do more stuff to movies
  I want to create and delete movies

Background: movies in database

  Given the following movies exist:
  | title        | rating | director     | release_date |
  | Star Wars    | PG     | George Lucas |   1977-05-25 |
  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
  | Alien        | R      |              |   1979-05-25 |
  | THX-1138     | R      | George Lucas |   1971-03-11 |

Scenario: delete movie
  Given I am on the details page for "Star Wars"
  And I press "Delete"
  Then I should be on the home page
  And I should see "Movie 'Star Wars' deleted"

Scenario: add movie
  Given I am on the "Create New Movie" page
  When I fill in "Title" with "Local Hero"
  And I press "Save Changes"
  Then I should be on the home page
  And I should see "was successfully created"
