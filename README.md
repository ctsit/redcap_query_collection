# REDCap Query Collection
A collection of SQL queries that shine light on your REDCap metadata

# Queries

* `system_stats_for_real_time_publication.sql` - statistics suitable for publication via [REDCap Web Services](https://github.com/ctsit/redcap_webservices)

* `count_active_projects.sql` - count of active projects within the last N days

# RMarkdown Reports

* `redcap_repo_report.Rmd` - statistics of REDCap External Modules released per institution; information on version, age, and download count of UF CTS-IT EMs.

* `module_maintainence.Rmd` - breakdown of EMs which likely need attention, inferred by GitHub activity and the REDCap EM repository
  - Requires configuration of an `.env` file, created from the `example.env` template.
