# Rails Engine

This API exposes fictional ecommerce data for item, merchant, and business inteligence endpoints. Most endpoints follow REST convention and all return a JSON response. See below for installation instructions and example queries. 

## Summary

  - [Installation](#installation)
  - [Querying Endpoints](#querying-endpoints)
    - [Merchants](#merchants)
    - [Items](#items)
    - [Business Intelligence](#business-intelligence)
  - [Example Queries](#example-queries)
    -[Creating A Merchant](#creating-a-merchant)
    -[Creating An Item](#createing-an-item)
    -[Returning A Merchant's Items](#returning-a-merchant's-items)
    -[Returning Top 10 Merchants With Most Revenue](#returning-top-10-merchants-with-most-revenue)
  - [Common Errors](#common-errors)
    -[Missing Parameter(s)](#missing-parameter(s))
    -[Non-existent Record](#non-existent-record)
  - [Contact](#contact)


## Installation

To access the API endpoints, clone this repository (see [here](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/cloning-a-repository) for more info) and run the following commands in your CLI: 
 1. Install gem dependencies: `bundle install`
 1. Import data: `bundle exec rake data:import`
 1. Run local server: `rails s`


## Querying Endpoints 

It is recommended that you use Postman to perform API queries. To download the postman app, visit: [this link.](https://www.postman.com/downloads/) The root url for all queries is `localhost:3000/api/v1` followed by the endpoint path specified below. Include an ID number of the resource for paths that require an :id (e.g. `/merchant/1`). 

Note: when making *POST* or *PATCH* queries, make sure the raw body is sent as JSON. 

<img src="https://i.ibb.co/5rnNkJv/Screen-Shot-2020-12-17-at-8-17-21-PM.png" alt="request-body-as-json" width=10%>


### Merchants 
 1. List all merchants: *GET* `/merchants'
 1. Return specific merchant: *GET* `/merchants/:id`
 1. Create merchant: *POST* `/merchants` 
    1. Within the body of the request, include: 
       ```{
            "name": "merchant name"
          } 
 1. Update merchant: *PATCH* `/merchant/:id` 
          {
            "name": "new merchant name"
          }   
 1. Delete merchant: *DELETE* `/merchants/:id`
      *Note: a successful delete will not return rendered JSON.*
 1. Return all items associated with a merchant: *GET* `/merchants/:id/items`
 1. Return a single merchant based on query parameters: *GET* `/merchants/find?<attribute>=<value>`
    1. Attributes include: *name, created_at,* and *updated_at*. Formating accepted for *created_at* and *updated_at* attributes is 'yyyy-mm-dd'. 
 1. Return (20) merchants that match set of criteria: *GET* `/merchants/find_all?<attribute>=<value>`
    1. Above attributes for find are accepted. 
 
 
### Items 
 1. List all items: *GET* `/items'
 1. Return specific item: *GET* `/items/:id`
 1. Create item: *POST* `/items` 
    1. Within the body of the request, include: 
       ```{
            "name": "item name", 
            "description": "item description (optional)",
            "unit_price": "item price (in dollars)", 
            "merchant_id": "existing merchant id"
          }
 1. Update item: *PATCH* `/items/:id` 
    1. Include any one, or more, of the attributes as listed above in the body of the request. 
 1. Delete item: *DELETE* `/items/:id`
       *Note: a successful delete will not return rendered JSON.*
 1. Return the merchant associated with an item: *GET* `/items/:id/merchants`
 1. Return a single item based on query parameters: *GET* `/items/find?<attribute>=<value>`
    1. Attributes include: *name, description, unit_price, merchant_id, created_at,* and *updated_at*. Formating accepted for *created_at* and *updated_at* attributes is 'yyyy-mm-dd'. 
 1. Return (20) items that match set of criteria: *GET* `/items/find_all?<attribute>=<value>`
    1. Above attributes for find are accepted. 
 
 
### Business Intelligence 

 1. Return a variable number of merchants ranked by total revenue: *GET* `/merchants/most_revenue?quantity=<number>`
 1. Return a variable number of merchants ranked by total number of items sold: *GET* `/merchants/most_items?quantity=<number>`
 1. Return the total revenue for all merchants between two dates: *GET* `/revenue?start=<start_date>&end=<end_date>`
    1. Formating accepted for *start_date* and *end_date* is 'yyyy-mm-dd'
 1. Return the total revenue for a specific merchant: *GET* `/merchants/:id/revenue`
 
 
 ## Example Queries 
  
 ### Creating A Merchant
 
 Query: 
 <img src="https://i.ibb.co/GMF0BS9/Screen-Shot-2020-12-17-at-8-08-50-PM.png" alt="creating-a-merchant" border="0">
 
 Result: 
 <img src="https://i.ibb.co/GCyyJ6b/Screen-Shot-2020-12-17-at-8-08-35-PM.png" alt="created-merchant-result" border="0">

 ### Creating An Item 
 
 Query (using merchant info above): 
 
 <img src="https://i.ibb.co/DgqXpwX/Screen-Shot-2020-12-17-at-8-19-19-PM.png" alt="creating-an-item" border="0">
 
 Result: 
 
 <img src="https://i.ibb.co/FhQLWLn/Screen-Shot-2020-12-17-at-8-19-36-PM.png" alt="created-item-result" border="0">
 
 ### Returning A Merchant's Items 
 
 Query: 
 
 <img src="https://i.ibb.co/0msr55j/Screen-Shot-2020-12-17-at-8-27-18-PM.png" alt="merchant-items-query" border="0">
 
 Result: 
 
 <img src="https://i.ibb.co/ykJYszr/Screen-Shot-2020-12-17-at-8-27-32-PM.png" alt="merchant-item-result" border="0">
 
 ### Returning Top 10 Merchants With Most Revenue
 
 Query: 
 
 <img src="https://i.ibb.co/LJ8jbqF/Screen-Shot-2020-12-17-at-8-30-09-PM.png" alt="top-10-most-revenue" border="0">
 
 Result (first three records): 
 
 <img src="https://i.ibb.co/2PGKcsC/Screen-Shot-2020-12-17-at-8-37-02-PM.png" alt="first-three-most-revenue" border="0">
 
 
 ## Common Errors 
 
 ### Missing Parameter(s)
 
 1. You will receive an error message similar to the following if missing a parameter when creating a record: 
 
 <img src="https://i.ibb.co/TMnzPVB/Screen-Shot-2020-12-17-at-8-41-20-PM.png" alt="missing-param-error" border="0">
 
 ### Non-existent Record 
 
 1. When an id that does not exist in the database is used for a show request, you will receive the following error: 
 
 <img src="https://i.ibb.co/Ry1QpYq/Screen-Shot-2020-12-17-at-8-41-44-PM.png" alt="non-existent-record-error" border="0">
 
 
 ## Contact 
 
 Author: Joshua Carey 
 [LinkedIn](https://www.linkedin.com/in/carey-joshua/)
 
