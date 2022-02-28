library(tidyverse)
library(rvest)

scrape_redcap_repo_data <- function(create_csv = FALSE) {

  url <- read_html("https://redcap.vanderbilt.edu/consortium/modules/index.php")

  # using html_table results in loss of github links
  # and require extraction of all fields other than dates and downloads
  redcap_modules <- url %>%
    html_nodes('#modules-table > tbody > tr')

  number_of_entries <- length(redcap_modules)

  get_private_git_repos <- function() {
    private_git_repo <- redcap_modules[[entry]] %>%
      html_nodes('td:nth-child(1) > div:nth-child(1)') %>%
      html_text() %>%
      str_detect(., "Private repository")

    tibble(entry = entry, private_git_repo = private_git_repo)
  }

  private_git_repos <- list()
  for (entry in c(1:number_of_entries)) {
    private_git_repos[[entry]] <- get_private_git_repos()
  }

  private_git_repos <- bind_rows(!!!private_git_repos) %>%
    filter(private_git_repo)

  scrape_redcap_repo <- function(entry) {
    title <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(1) > div:nth-child(1) > span') %>%
    html_text()

    deployed <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(1) > div:nth-child(1) > i') %>%
    html_text()

    github_url <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(1) > div:nth-child(2) > a:nth-child(1)') %>%
    html_attr("href")

    description <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(1) > div:nth-child(3)') %>%
    html_text()

    date_added <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(2)') %>%
    html_text()

    last_updated <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(3)') %>%
    html_text()

    downloads <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(4)') %>%
    html_text() %>%
    str_remove(., ",") %>%
    as.integer()

    author <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(1) > div:nth-child(4) > a') %>%
    html_text() %>%
    unique() %>%
    paste(collapse = ", ")

    author_email <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(1) > div:nth-child(4) > a') %>%
    html_attr("href") %>%
    unique() %>%
    paste(collapse = ", ")

    institution <- redcap_modules[[entry]] %>%
    html_nodes('td:nth-child(1) > div:nth-child(4) > span') %>%
    html_text() %>%
    unique() %>%
    paste(collapse = ", ")

    tibble(title = title, deployed = deployed, github_url = github_url,
           description = description, date_added = date_added, last_updated = last_updated,
           downloads = downloads, author = author, author_email = author_email, institution = institution)
  }

  # exclude any private github repos
  if (nrow(private_git_repos) == 0) {
    redcap_repo_entries <- (1:number_of_entries)
  } else {
    redcap_repo_entries <- (1:number_of_entries)[-private_git_repos$entry]
  }

  redcap_repo_data <- list()
  for (entry in redcap_repo_entries) {
    redcap_repo_data[[entry]] <- scrape_redcap_repo(entry)
  }

  redcap_repo_data <- bind_rows(!!!redcap_repo_data) %>%
    mutate_at(vars(c("deployed", "institution")), ~ str_remove_all(., "\\(|\\)")) %>%
    mutate_at(vars(c("description", "author_email")), ~ str_remove_all(., "Description: |mailto:")) %>%
    mutate(version = str_extract(deployed, "v\\d.+"),
           deployed = str_remove(deployed, "_v\\d.+")) %>%
    select(title, deployed, version, everything())

  if (create_csv) {
    write.csv(redcap_repo_data, "redcap_repo_data.csv", row.names = F, na = "")
  }

  return(redcap_repo_data)
}
