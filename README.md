# README

# テーブル構成（FamCook）

## usersテーブル
|Column	                 | Type	     | Options
|------------------------|-----------|--------------------------------|
|name	                   | string	   | null: false                    |
|email	                 | string	   | null: false, unique: true      |
|encrypted_password	     | string	   | null: false                    |
|reset_password_token	   | string	   |                                |
|reset_password_sent_at  | datetime	 |                                |
|family_id	             | integer	 |                                |

### Association
-belongs_to :family, optional: true
-has_many :meals
-has_many :memos
-has_many :comments


## familiesテーブル
|Column	                 | Type	     | Options
|------------------------|-----------|--------------------------------|
|name	                   | string	   | 任意入力                        |
|code	                   | string	   | null: false, unique: true      |

### Association
-has_many :users
-has_many :meals
-has_many :memos


## mealsテーブル
|Column	                 | Type	      | Options
|------------------------|------------|--------------------------------|
|title	                 | string	    |                                |
|description	           | text	      |                                |
|date	                   | date	      |                                |
|meal_type	             | integer	  | default: 2（夕食）              |
|icon_type	             | integer	  |                                |
|user	                   | references	| null: false, foreign_key: true |
|family_id	             | integer	  |                                |

※ images は ActiveStorage にて管理

### Association
-belongs_to :user
-belongs_to :family
-has_many :comments, dependent: :destroy
-has_many_attached :images


## commentsテーブル
|Column	                 | Type	      | Options
|------------------------|------------|--------------------------------|
|user	                   | references	| null: false, foreign_key: true |
|meal	                   | references	| null: false, foreign_key: true |
|rating	                 | integer	  | null: false                    |
|content	               | text	      |                                |

### Association
-belongs_to :user
-belongs_to :meal


## memosテーブル
|Column	                 | Type	      | Options
|------------------------|------------|--------------------------------|
|category          	     | string	    |                                |
|content                 | text	      |                                |
|pinned            	     | boolean	  | default: false, null: false    |
|user	                   | references | null: false, foreign_key: true |
|family_id	             | integer	  |                                |

### Association
-belongs_to :user
-belongs_to :family