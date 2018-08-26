
# add request_type variable to categories and set it equal to issue. This will allow you to
# keep the original issue category during the join

categories$request_type <- categories$issue

data_req <- data_311 %>%
  group_by(request_type, department) %>%
  summarise(requests = n())


# find rows in categories that don't have a match in data_req

data_req <- full_join(data_req, categories, by='request_type')

data_req <- arrange(data_req, request_type)

# output to csv because using the R editor is too painful
write_csv(data_req,'raw_data/311-codebook-request-types-revised.csv')

