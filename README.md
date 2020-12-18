# Rails Engine

This API exposes fictional ecommerce data for item, merchant, and business inteligence endpoints. Most endpoints follow REST convention and all return a JSON response. See below for installation instructions and example queries. 

## Summary

  - [Installation](#installation)
  - [Querying Endpoints](#querying-endpoints)
    - [Merchants](#merchants)
    - [Items](#items)
    - [Business Intelligence](#business-intelligence)
  - [Example Queries](#example-queries)
  - [Common Errors](#common-errors)
    

## Installation

To access the API endpoints, clone this repository (see [here](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/cloning-a-repository) for more info) and run the following commands in your CLI: 
 1. Install gem dependencies: `bundle install`
 1. Import data: `bundle exec rake data:import`
 1. Run local server: `rails s`

## Querying Endpoints 

It is recommended that you use Postman to perform API queries. To download the postman app, visit: [this link.](https://www.postman.com/downloads/) The root url for all queries is `localhost:3000/api/v1` followed by the endpoint path specified below. Include an ID number of the resource for paths that require an :id (e.g. `/merchant/1`) 

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
 
 
 
 <img src="https://jdcarey128.imgbb.com/" alt="creating-a-merchant">
