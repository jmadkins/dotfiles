# Rails rules

These rules apply to each Rails project that imports this file. A project's own CLAUDE.md can add to them or
override them.

## Architecture

1. Follow Rails conventions strictly. Vanilla Rails is enough.
2. Use rich domain models (Active Record models and plain Ruby objects, together in `app/models`). Put all business
   logic there. Do not put it in a controller, view, helper or job. Do not add services, actions, commands,
   interactors or repositories.
3. Controllers call domain methods directly: `@yard_sign.claim!(Current.user)`,
   `@contribution_commitment.pause!(reason: :staff)`, `@contest.merge_into!(canonical, user: Current.user)`.
4. A model exposes a natural verb and hides the work: `canvass.clone_now(options)`, not
   `CanvassCloneService.new(canvass).call`. When the work is complex, the verb hands off to a plain Ruby class with
   one job in the model's namespace (`Canvass::Cloner.new(self).run(options)`).
5. A concern is one trait of its host model ("acts as" or "has a"). Do not use concerns to split a big model into
   parts. Put a model's own concerns in `app/models/<model>/` (`YardSign::Claimable`, `YardSign::Droppable`,
   `Contest::Mergeable`) and shared ones in `app/models/concerns` (`Approvable`, used by `Office`, `Contest`,
   `Incumbent` and `BallotChoice`).
6. Name things boldly in the domain's own words, not in neutral technical words: a volunteer `drop!`s a yard sign, a
   frozen campaign is `chilled`, `EmailTransaction::Postmaster` refuses a mailing, `EmailTransaction::Tranches` sends
   it in daily parts. Not `SignStatusUpdater`, `RestrictedMode` or `EmailValidator`. For a complex model, write a
   plain-text description first.
7. A job accepts ids, finds the record, sets `Current`, and calls one model method. It has no other logic.
8. Use the now/later pattern. The model owns both methods:

```ruby
module Census::Processable
  extend ActiveSupport::Concern

  def process_now
  end

  def process_later
    Census::Job.perform_later id
  end
end

class Census::Job < ApplicationJob
  def perform(id)
    census = Census.find(id)
    Current.universe = census.universe
    census.process_now
  end
end
```

9. `Current` holds the request context (the user, the session, the tenant). Set it in the controller or the job. Do
   not bypass it.
10. Use ViewComponents in `app/components/<namespace>/` for reusable UI. Do not build a family of partials that share
   a helper. One small partial in one view is fine.
11. Put external API clients and their DTO mappers in `app/gateways`.
12. Keep each business rule in one method, and call that method everywhere. Before you write logic such as "may this
    user see this file" or "is this license past due", search for the method that already owns it
    (`Recording#accessible_by?`, `License#billing_state`) and call it. Do not write a second copy in a controller,
    view, job or query.

## Doctrine

1. Optimize for programmer happiness. All code must be beautiful, readable and maintainable Ruby on Rails code.
   - Write idiomatic Ruby that reads like a sentence: guard clauses, `presence`, keyword arguments, `each_with_object`,
     safe navigation.
   - Keep methods short, with one level of abstraction in each. Give a name to an intermediate value instead of
     nesting calls.
   - Obvious is better than clever. Write for the developer who reads the code in a year.
   - Do not add defensive checks, options, abstractions or configuration that no caller needs.
   - Before you hand back code, read it again. If a Rails developer would not enjoy reading it, simplify it.
2. Declare model behavior with class macros at the top of the class (`belongs_to`, `has_many`, `validates`, `scope`,
   `enum`). Write conditions that read from the subject: `person.in?(people)`.
3. Use the sharp tools of Rails when they make code clearer: concerns, class macros, `Current`, and Active Support
   extensions (`2.days.ago`, `in?`). Do not replace them with longer "safe" patterns. Do not monkey-patch a class
   without asking.
4. Use the Rails default (or the library already in the Gemfile) before you add a gem. Ask before you add a gem that
   replaces a default or duplicates one in the Gemfile.
5. Keep one app. Serve JSON from the same models and controllers with Jbuilder. Do not add a service, a second app,
   or client templates that copy server views, unless an outside system needs one.
6. Leave a convention only for a real reason, and write that reason in a comment. When a test prints a deprecation
   warning, fix it or report it.

## Routes

- Nest an index under its parent (`/mailboxes/:id/conversations`) and find the parent through its owner. Do not
  filter with `?parent_id=`.
- Use a named collection route for a state view (`/emails/sent`), not `?status=`. Only `page` stays a query
  parameter.

## Database

- Put data rules in model validations with tests. Do not use database check constraints. Indexes (also partial
  unique indexes) are fine.
- Before you write a migration, look in `db/schema.rb` for an existing column that can hold the data. Ask before you
  add a migration.

## Tests and tools

- Use Minitest and the existing fixtures. Do not make a new record when a fixture fits.
- Lint and format with StandardRB (`bin/standardrb`).
- Verify with tests (`bin/rails test <files>`). Do not write `bin/rails runner` smoke scripts.
