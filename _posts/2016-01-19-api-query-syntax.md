---
layout: post
title:  "Rinocloud query language"
date:   2016-01-18 07:34:57 +0000
author: Eoin
categories: blog
---

The Rinocloud search functionality is based on the awesome [elasticsearch](http://elastic.co).

Building queries from the following "mini-language" allows you to quickly find the data you want in Rinocloud.

#### You can search by field and value:

  ```
    field:value
  ```

#### OR

  ```
  color:(red OR blue)
  ```

#### EXACT

  ```
  author:"John Smith"
  ```

will match where the author field contains the exact phrase "john smith".

#### Wildcards

Wildcard searches can be run on individual terms, using ? to replace a single character, and * to replace zero or more characters:

```
qu?ck bro*
```

#### Regular expressions

Regular expression patterns can be embedded in the query string by wrapping them in forward-slashes ("/"):

```
name:/joh?n(ath[oa]n)/
```

#### Fuzziness

We can search for terms that are similar to, but not exactly like our search terms, using the “fuzzy” operator:

```
quikc~ brwn~ foks~
```

This uses the Damerau-Levenshtein distance to find all terms with a maximum of two changes, where a change is the insertion, deletion or substitution of a single character, or transposition of two adjacent characters.

The default edit distance is 2, but an edit distance of 1 should be sufficient to catch 80% of all human misspellings. It can be specified as:

```
quikc~1
```

#### Proximity searches

While a phrase query (eg "john smith") expects all of the terms in exactly the same order, a proximity query allows the specified words to be further apart or in a different order. In the same way that fuzzy queries can specify a maximum edit distance for characters in a word, a proximity search allows us to specify a maximum edit distance of words in a phrase:

```
"fox quick"~5
```

The closer the text in a field is to the original order specified in the query string, the more relevant that document is considered to be. When compared to the above example query, the phrase "quick fox" would be considered more relevant than "quick brown fox".

#### Ranges

Ranges can be specified for date, numeric or string fields. Inclusive ranges are specified with square brackets [min TO max] and exclusive ranges with curly brackets {min TO max}.

All days in 2012:

```
date:[2012-01-01 TO 2012-12-31]
```

Numbers 1..5

```
count:[1 TO 5]
```

Tags between alpha and omega, excluding alpha and omega:

```
tag:{alpha TO omega}
```

Numbers from 10 upwards

```
count:[10 TO *]
```

Dates before 2012

```
date:{* TO 2012-01-01}
```

Curly and square brackets can be combined:
Numbers from 1 up to but not including 5

```
count:[1 TO 5}
```

Ranges with one side unbounded can use the following syntax:

```
age:>10
age:>=10
age:<10
age:<=10
```

Note:
To combine an upper and lower bound with the simplified syntax, you would need to join two clauses with an AND operator:

```
age:(>=10 AND <20)
age:(+>=10 +<20)
```

The parsing of ranges in query strings can be complex and error prone. It is much more reliable to use an explicit range query.

#### Boosting

Use the boost operator ^ to make one term more relevant than another. For instance, if we want to find all documents about foxes, but we are especially interested in quick foxes:

```
quick^2 fox
```

The default boost value is 1, but can be any positive floating point number. Boosts between 0 and 1 reduce relevance.

Boosts can also be applied to phrases or to groups:

```
"john smith"^2   (foo bar)^4
```

Boolean operators

By default, all terms are optional, as long as one term matches. A search for foo bar baz will find any document that contains one or more of foo or bar or baz. We have already discussed the default_operator above which allows you to force all terms to be required, but there are also boolean operators which can be used in the query string itself to provide more control.

The preferred operators are + (this term must be present) and - (this term must not be present). All other terms are optional. For example, this query:

```
quick brown +fox -news
```

states that:

- fox must be present
- news must not be present
- quick and brown are optional — their presence increases the relevance

The familiar operators AND, OR and NOT (also written &&, \|\| and !) are also supported. However, the effects of these operators can be more complicated than is obvious at first glance. NOT takes precedence over AND, which takes precedence over OR. While the + and - only affect the term to the right of the operator, AND and OR can affect the terms to the left and right.

#### Empty Queryedit

If the query string is empty or only contains whitespaces the query will yield an empty result set.
