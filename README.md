# JSON Search

Searches all the values in all the JSON files present in the `json_files` folder and displays the result in human readable format.

# Setup

<strong>Important:</strong> Create a PostgreSQL database with the name `json_search`.
 And, mention the database credentials in `db/connection.rb` file.
 <br>
If the above step are done, then follow the below mentioned steps from the project's root folder.

`$ bundle install` <br>
`$ bin/setup_schema` <br>

# Run

There are two steps involved. 
- Indexing -
Before the search is performed, all the files needs to be indexed. Place all the files `json_files` folder and run, <br>
`$ bin/index_json_files`

* Remember: For every new files placed, `bin/index_json_files` needs to be run.

- Searching for values -
Once indexes, files are ready to be searched. To search, <br>
`$ bin/search_json "Miss Joni"`

# Example
`$ bin/search_json "Miss Joni"` <br>

```
************* 1 **************

id                            : 2 
External id                   : c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2 
Name                          : Joni Mitchell 
Alias                         : Miss Joni 
Created at                    : 2016-06-23T10:31:39 -10:00 
Active                        : true 
Verified                      : true 
Shared                        : false 
Locale                        : zh-CN 
Timezone                      : Armenia 
Last login at                 : 2012-04-12T04:03:28 -10:00 
Email                         : test2@example.com 
Phone                         : 9575-552-585 
Signature                     : Don't Worry Be Happy! 
Organization id               : 106 
Tags                          : Foxworth Woodlands Herlong Henrietta 
Suspended                     : false 
Role                          : member 
Location                      : City => Melbourne 

************* 2 **************

id                            : 3 
External id                   : c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2 
Name                          : Joni Mitchell2 
Alias                         : Miss Joni 
Created at                    : 2016-06-23T10:31:39 -10:00 
Active                        : true 
Verified                      : true 
Shared                        : false 
Locale                        : zh-CN 
Timezone                      : Armenia 
Last login at                 : 2012-04-12T04:03:28 -10:00 
Email                         : test3@example.com 
Phone                         : 9575-552-585 
Signature                     : Don't Worry Be Happy! 
Organization id               : 106 
Tags                          : Foxworth Woodlands Herlong Henrietta 
Suspended                     : false 
Role                          : member 
Location                      : City => Melbourne 

----------------------------------------------------------------------------------------------------

```

`$ bin/search_json "Melbourne"` <br>

```
------------------------------------------- PROJECTS (1) -------------------------------------------


************* 1 **************

id                            : 102 
Url                           : http://example.com/projects-2 
External id                   : 7cd6b8d4-2999-4ff2-8cfd-44d05b449226 
Name                          : Project with HP 
Location                      : Melbourne Singapore 
Created at                    : 2016-04-07T08:21:44 -10:00 
Details                       : Non profit 
Published                     : false 
Tags                          : Trevino 

----------------------------------------------------------------------------------------------------

-------------------------------------------- USERS (2) ---------------------------------------------


************* 1 **************

id                            : 2 
External id                   : c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2 
Name                          : Joni Mitchell 
Alias                         : Miss Joni 
Created at                    : 2016-06-23T10:31:39 -10:00 
Active                        : true 
Verified                      : true 
Shared                        : false 
Locale                        : zh-CN 
Timezone                      : Armenia 
Last login at                 : 2012-04-12T04:03:28 -10:00 
Email                         : test2@example.com 
Phone                         : 9575-552-585 
Signature                     : Don't Worry Be Happy! 
Organization id               : 106 
Tags                          : Foxworth Woodlands Herlong Henrietta 
Suspended                     : false 
Role                          : member 
Location                      : City => Melbourne 

************* 2 **************

id                            : 3 
External id                   : c9995ea4-ff72-46e0-ab77-dfe0ae1ef6c2 
Name                          : Joni Mitchell2 
Alias                         : Miss Joni 
Created at                    : 2016-06-23T10:31:39 -10:00 
Active                        : true 
Verified                      : true 
Shared                        : false 
Locale                        : zh-CN 
Timezone                      : Armenia 
Last login at                 : 2012-04-12T04:03:28 -10:00 
Email                         : test3@example.com 
Phone                         : 9575-552-585 
Signature                     : Don't Worry Be Happy! 
Organization id               : 106 
Tags                          : Foxworth Woodlands Herlong Henrietta 
Suspended                     : false 
Role                          : member 
Location                      : City => Melbourne 

----------------------------------------------------------------------------------------------------

```

`$ bin/search_json "Missing Joni"` <br>
`No results.`

# Test
`$ rspec`
