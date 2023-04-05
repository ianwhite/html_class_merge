# html_class_merger

`html_class_merger` is a crystal shard that enables you specify how html classes should be merged, and so merges them.

## Motivation

When building a HTML page, especially with utility frameworks, you might want to specify a base set of html classes
for an element, and later specify variants, eg. base button class: `"rounded px-3 py-2 bg-gray-100 text-gray-800"`, and primary variant: `"bg-blue-700 text-white"`.

Concatenating these would give `"rounded px-3 py-2 bg-gray-100 text-gray-800 bg-blue-700 text-white"`.  This may achieve the desired effect, but it will depend on how the CSS is structured, and is brittle, because there are conflicting classes present (two bg colour and two text colour classes).  This problem gets worse with utility frameworks, and you find yourself having to specify the entire variant list of html classes, rather that just specifying the differences.

If we know that the `bg-` and `text-` classes are grouped together, then we can programatically merge the above two html classes as: `"rounded px-3 py-2 bg-blue-700 text-white"`.

Furthermore, if our merger knows about padding and text size, we could add another variant `"text-lg py-5 px-6"` (large), and merge that, giving `"rounded bg-blue-700 text-white text-lg py-5 px-6"`.

## What knowledge the html class merger can use, and in what way

- What **group** a html class belongs to, specified as a list of Strings, or Regular expressions
- What groups **replace** other groups, for example, `:border_width` group should replace more specific border width classes `:border_width_x`,... , but not the other way around
- Are there **scopes** that further divide the html classes? For example, a background colour group should not ovveride a *hover* background colour group, but within the *hover* scope, background colour groups should apply in the same way
- Some html classes marked as **important** should not be overridden by subsequent html classes in the same group

By default `HtmlClassMerger` provides a way of configuring what html classes are in a **group**, and what groups **replace** other groups.

`HtmlClassMerger` provides template methods for determining **scope**, and whether a html class is **important**, which implementations can make use of.

`TailwindClassMerger` extends the above with the knowledge of important and scopes.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  html_class_merger:
    github: ianwhite/html_class_merger
```

2. Run `shards install`

## Usage

```crystal
require "html_class_merger"
```

## Example

An example of tailwind like syntax (simplified)

```crystal
borders = HtmlClassMerger.new
borders.register! :border, [/border-\d/, "border-none"], replace: "border_x border_y"

{ "x" => ["l", "r"], "y" => ["t", "b"] }.each do |axis, sides|
  borders.register! "border_#{axis}", [/border-#{axis}-\d/, "border-#{axis}-none"], replace: sides.map { |s| "border_#{s}" }
  sides.each do |side|
    borders.register! "border_#{side}", [/border-#{side}-\d/, "border-#{side}-none"]
  end
end

borders.merge("border-l-2 border-x-2")                     # => "border-x-2"
borders.merge("border-l-2 border-t-2 border-1")            # => "border-1"
borders.merge("border-l-2 border-t-2 border-y-2")          # => "border-l-2 border-y-2"
borders.merge("border-l-2 border-x-2 border-3 border-l-1") # => "border-4 border-l-1"
```

## Development

Run the tests with `crystal spec`

## Contributors

- [Ian White](https://github.com/ianwhite) - creator and maintainer
