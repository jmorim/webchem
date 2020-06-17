context("goodscents")

test_that('tgsc_percept()', {
  skip_on_cran()

  phenylacetaldehyde.tgsc <- tgsc_percept('122-78-1')
  multi.tgsc <- tgsc_percept(c('122-78-1', '127-91-3'))
  phenylacetaldehyde.tgsc.odor <- tgsc_percept('122-78-1', odor = T)
  multi.tgsc.odor <- tgsc_percept(c('122-78-1', '127-91-3'), odor = T)

  expect_equivalent(phenylacetaldehyde.tgsc,
                    'green sweet floral hyacinth clover honey cocoa')
  expect_equivalent(multi.tgsc,
                    c('green sweet floral hyacinth clover honey cocoa',
                    'dry woody resinous pine hay green'))
  expect_equal(phenylacetaldehyde.tgsc, phenylacetaldehyde.tgsc.odor)
  expect_equal(multi.tgsc, multi.tgsc.odor)

  phenylacetaldehyde.flavor <- tgsc_percept('122-78-1', odor = F, flavor = T)
  multi.flavor <- tgsc_percept(c('122-78-1', '127-91-3'), odor = F, flavor = T)

  expect_equivalent(phenylacetaldehyde.flavor,
                    'honey, sweet, floral, chocolate and cocoa, with a spicy nuance')
  expect_equivalent(multi.flavor,
                    c('honey, sweet, floral, chocolate and cocoa, with a spicy nuance',
                    'fresh, piney and woody, terpy and resinous with a slight minty, camphoraceous with a spicy nuance'))

  phenylacetaldehyde.all <- tgsc_percept('122-78-1', flavor = T)
  multi.all <- tgsc_percept(c('122-78-1', '127-91-3'), flavor = T)

  expect_equivalent(phenylacetaldehyde.all, list(c('green sweet floral hyacinth clover honey cocoa',
                              'honey, sweet, floral, chocolate and cocoa, with a spicy nuance')))
  expect_equivalent(multi.all, list(c('green sweet floral hyacinth clover honey cocoa',
                              'honey, sweet, floral, chocolate and cocoa, with a spicy nuance'),
                    c('dry woody resinous pine hay green',
                      'fresh, piney and woody, terpy and resinous with a slight minty, camphoraceous with a spicy nuance')))
})
