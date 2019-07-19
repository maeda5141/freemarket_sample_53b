# freemarket_sample_53b
It is a copy site of popular freemarket application.
We are Osaka Tech::Expert 53term. The team B!
The final product of the team B.

# Database design

## Users table
|Column|Type|Options|
|------|----|-------|
|email|string|null: false, unique: ture|
|nickname|string|null: false|
|first_name|string|
|last_name|string|
|first_name_kana|string|
|last_name_kana|string|
|birthday|integer|
|image|string|
|postal_cade|integer|
|prefecture|string|
|city|string|
|address_number|integer|
|building|string|
|tell|integer|
|gender|string|
|profile|text|

### association

- has_many :items
- has_many :credits
- has_many :buy_histories
- has_many :comments

## Items table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|price|integer|null: false|
|description|text|
|status|string|
|delivery_burden|string|
|delivery_method|string|
|delivery_prefecture|string|
|delivery_time|string|
|category_id|references|null: false, foreign_key: true|
|user_id|references|null: false, foreign_key: true|

### association
- belongs_to :user
- belongs_to :category
- has_many :comments
- has_many :images
- has_one :buy_history


## Comments table
|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, foreign_key: true|
|item_id|references|null: false, foreign_key: true|
|text|text|
|delete_flag|boolean|

### association
- belongs_to :item
- belongs_to :user

## Buy_histories table
|Column|Type|Options|
|------|----|-------|
|user_id|references|null: false, foreign_key: true|
|item_id|references|null: false, foreign_key: true, unique: true|

### association
- belongs_to :user
- belongs_to :item

## Credits table
|Column|Type|Options|
|------|----|-------|
|credit_number|integer|null: false|
|expiry_date|integer|null: false|
|security_code|integer|null: false|
|user_id|integer|null: false, foreign_key: true|

### association
- belongs_to :user


## Images table  
|Column|Type|Options|
|------|----|-------|
|item_id|references|null: false,foreign_key: true|
|image_url|string|

### association
- belongs_to :item

## categories table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|parent_id|references|

### association
- has_many :items

testtesttest

