 Mobilink Subscription Server
========================


The server provides API's for **[Mobilink Jazz](https://www.mobilink.com.pk/)**.  and **[STC](http://www.stc.com.sa/wps/wcm/connect/english/individual/individual)** 
The STC subscription need SDPKSA for **Datasync** but Mobilink subscription don't 

<i class="icon-cog"></i>**Admin Panel** 
http://mobisub.cricwick.mobi/admin.
<i class="icon-user"></i>**User:** `admin` **password:** `cricsub`

<i class="icon-cog"></i>**Notification Panel** 
http://mobisub.cricwick.mobi/notifications.
<i class="icon-user"></i>**User:** `user` **password:** `cricsub`

----------

Mobilink Subscription Overview
-------------

App/Portal user can subscribe to **champion** and **non-champion** package. champion package has validity of 30 days and no-champion lasts 7 days only. the current charges for champion packages are `20 PKR + Tax` and for non-champion it is `5 PKR + Tax`.

> **Subscription Model:**

> - A new user subscribe over portal/app will be given 7 days free trial. and no charges will be deducted. during trial period user can use all the paid feature of portal/app. if a user un subscribe on his own consent then trial period will be over.
> - While subscription when user trial period is over. the user is marked as in-active but will not be auto charged by app/portal. charging user will is based on user consent, meeting following two criteria for both packages.
> - **Champion Package:** user will always be prompted if he wants to continue package and on approval user will be charged. or else will be in in-active state.
> - **Non-Champion Package:** for the first time when user trial is over, user will be prompted that if he wants to continue package. if so then user will be charged and schedule for auto renewal of package by setting expiry and recharging dates. ( the [<i class="icon-refresh"></i> Cron Job](#CRONJOBS) does package renewal and pushes messages to user mobile).

#### <i class="icon-file"></i> Technical Details

The document section explain <i class="icon-cog"> Subscription API</i> and subscription model in technical norms. 

----------

#### <i class="icon-folder-open"></i> Send PIN API

**http://mobisub.cricwick.mobi/main/send_pin?phone=03133139966&udid=1234udid4321** 

1. The api send PIN message to subscriber and create new subscriber if not already exist. 
2. The phone number is validated by [authenticate_phone_number](http://leafback.funworldpk.com/home/find_telco?phone=03133139966) method.
3. Package is selected by Mobilink by getting `service_class_id`
if returned `service_class_id` is `19` or `27` then champion/monthly package is selected by setting `subscription_type = 1` or else do weekly subscription by setting `subscription_type = 0`
4. If post paid number then always set champion/monthly package

<kbd>phone</kbd> and <kbd>udid</kbd> are mandatory. the returned response is in <kbd>JSON</kbd> format.

**Send PIN API Response:**
> {
  "status": 1,
    "status_message": "ok",
    "resp": {
        "status": 1,
        "status_text": "Sent!"
    }
}

----------

#### <i class="icon-folder-open"></i> Confirm PIN API

**http://mobisub.cricwick.mobi/main/confirm_pin_n_sub?phone=03133139966&udid=1234udid4321&pin=8849** 

The API confirm as well as subscribe user after successful verification. 
The API updates:
user trial `start` and `end` dates. send `welcome` message to new user. for new user `status=2` and `current_tick=1` which means user is in-active but on trial.

<kbd>phone</kbd> <kbd>pin</kbd> and <kbd>udid</kbd> are mandatory. the returned response is in <kbd>JSON</kbd> format.

**Confirm PIN API Response:**
> {
    "status": 1,
    "subscription_phone": {
        "id": 701,
        "phone": "03133139966",
        "pin": "8849",
        "total_amount": 20,
        "total_days": 30,
        "status": 1,
        "total_installments": 1,
        "succesfull_installments": 1,
        "current_tick": 0,
        "unsub_reason": null,
        "created_at": "December 13, 2016 11:50",
        "updated_at": "December 13, 2016 11:50",
        "udid": "1234udid4321",
        "next_billing": "January 12, 2017 14:17",
        "last_billed": "December 13, 2016 14:17",
        "renewal_date": "2017-01-12 14:17:41 UTC",
        "reattempt_billing": null,
        "subscription_type": 1,
        "trial_started_at": "2016-12-13T13:24:43.000Z",
        "trial_ended_at": "2016-12-13T14:16:53.000Z",
        "gcm_token": null,
        "is_postpaid": false,
        "telco_id": 5,
        "last_billed_ts": 1481638661,
        "next_billing_ts": 1484230661,
        "renewal_date_ts": 1484230661,
        "free_trial": 0,
        "remain_days": 0,
        "free_trial_over_msg": "Your trial period is over, please subscribe to enjoy Jazz Cricwick services. Package charges PKR 20+Tax/month.",
        "welcome_free_trial": "Welcome to Jazz CricWick, you have been awarded 0 days free trial period."
    }

----------

#### <i class="icon-folder-open"></i> Direct Subscribe API

**http://mobisub.cricwick.mobi/main/direct_subscribe_user?phone=03133139966&udid=1234udid4321**

The API only charges existing user. and on successful charge response from mobilink, it updates user subscription and mark active. else it marks in-active.

<kbd>phone</kbd> and <kbd>udid</kbd> are mandatory. the returned response is in <kbd>JSON</kbd> format.

**Direct Subscribe API Response:**
>{
    "status": 1,
    "subscription_phone": {
        "id": 701,
        "phone": "03133139966",
        "pin": 8849,
        "total_amount": 20,
        "total_days": 30,
        "status": 2,
        "total_installments": 0,
        "succesfull_installments": 0,
        "current_tick": 0,
        "unsub_reason": null,
        "created_at": "December 13, 2016 11:50",
        "updated_at": "December 13, 2016 11:50",
        "udid": "1234udid4321",
        "next_billing": null,
        "last_billed": "December 13, 2016 14:17",
        "renewal_date": "",
        "reattempt_billing": "2016-12-22T11:11:59.062Z",
        "subscription_type": 1,
        "trial_started_at": "2016-12-13T13:24:43.000Z",
        "trial_ended_at": "2016-12-13T14:16:53.000Z",
        "gcm_token": null,
        "is_postpaid": false,
        "telco_id": 5,
        "last_billed_ts": 1481638661,
        "next_billing_ts": 0,
        "renewal_date_ts": 0
    }
}

----------

#### <i class="icon-folder-open"></i> Un Subscribe API

**http://mobisub.cricwick.mobi/main/unsubscribe?phone=03133139966&unsub_reason=1**

The API un subscribe user from App/Portal and mark it un subscribe by setting `status=0`.

  **Un Subscribe Reasons :**
:   1 = User Unsub
:   2 = Customer Care Unsub
:   3 = Low Balance Unsub
:   6 = Auto Unsub due to non-usage of service

<kbd>phone</kbd> and <kbd>unsub_reason</kbd> are mandatory. the returned response is in <kbd>JSON</kbd> format.

**Un Subscribe API Response:**
>{
    "status": 1,
    "status_message": "unsubscribed",
    "user": {
        "id": 701,
        "phone": "03133139966",
        "pin": null,
        "total_amount": 20,
        "total_days": 30,
        "status": 0,
        "total_installments": 0,
        "succesfull_installments": 0,
        "current_tick": 0,
        "unsub_reason": 1,
        "created_at": "December 13, 2016 11:50",
        "updated_at": "December 13, 2016 11:50",
        "udid": "1234udid4321",
        "next_billing": null,
        "last_billed": "December 13, 2016 14:17",
        "renewal_date": "",
        "reattempt_billing": null,
        "subscription_type": 1,
        "trial_started_at": "2016-12-13T13:24:43.000Z",
        "trial_ended_at": "2016-12-13T14:16:53.000Z",
        "gcm_token": null,
        "is_postpaid": false,
        "telco_id": 5,
        "last_billed_ts": 1481638661,
        "next_billing_ts": 0,
        "renewal_date_ts": 0,
        "free_trial": 0,
        "remain_days": 0,
        "free_trial_over_msg": "Your trial period is over, please subscribe to enjoy Jazz Cricwick services. Package charges PKR 20+Tax/month."
    }
}

----------

#### <i class="icon-folder-open"></i> Find Subscriber by Phone API

**http://mobisub.cricwick.mobi/main/find_sub_by_phone?phone=03133139966**

The API return subscriber object by looking it by phone.

<kbd>phone</kbd> is mandatory. the returned response is in <kbd>JSON</kbd> format.

**Find Subscriber by Phone :**
>{
    "status": 1,
    "status_message": "ok",
    "user": {
        "id": 701,
        "phone": "03133139966",
        "pin": null,
        "total_amount": 20,
        "total_days": 30,
        "status": 0,
        "total_installments": 0,
        "succesfull_installments": 0,
        "current_tick": 0,
        "unsub_reason": 1,
        "created_at": "December 13, 2016 11:50",
        "updated_at": "December 13, 2016 11:50",
        "udid": "1234udid4321",
        "next_billing": null,
        "last_billed": "December 13, 2016 14:17",
        "renewal_date": "",
        "reattempt_billing": null,
        "subscription_type": 1,
        "trial_started_at": "2016-12-13T13:24:43.000Z",
        "trial_ended_at": "2016-12-13T14:16:53.000Z",
        "gcm_token": null,
        "is_postpaid": false,
        "telco_id": 5,
        "last_billed_ts": 1481638661,
        "next_billing_ts": 0,
        "renewal_date_ts": 0,
        "free_trial": 0,
        "remain_days": 0,
        "free_trial_over_msg": "Your trial period is over, please subscribe to enjoy Jazz Cricwick services. Package charges PKR 20+Tax/month.",
        "welcome_free_trial": "Welcome to Jazz CricWick, you have been awarded 0 days free trial period."
    },
    "subscribed_streams": [],
    "live_stream_price": 0
}

----------

#### <i class="icon-folder-open"></i> Find Subscriber by UDID API

**http://mobisub.cricwick.mobi/main/find_sub_by_udid?udid=1234udid4321**

The API return subscriber object by looking it by UDID.

<kbd>udid</kbd> is mandatory. the returned response is in <kbd>JSON</kbd> format.

**Find Subscriber by UDID :**
>{
    "status": 1,
    "status_message": "ok",
    "user": {
        "id": 701,
        "phone": "03133139966",
        "pin": null,
        "total_amount": 20,
        "total_days": 30,
        "status": 0,
        "total_installments": 0,
        "succesfull_installments": 0,
        "current_tick": 0,
        "unsub_reason": 1,
        "created_at": "December 13, 2016 11:50",
        "updated_at": "December 13, 2016 11:50",
        "udid": "1234udid4321",
        "next_billing": null,
        "last_billed": "December 13, 2016 14:17",
        "renewal_date": "",
        "reattempt_billing": null,
        "subscription_type": 1,
        "trial_started_at": "2016-12-13T13:24:43.000Z",
        "trial_ended_at": "2016-12-13T14:16:53.000Z",
        "gcm_token": null,
        "is_postpaid": false,
        "telco_id": 5,
        "last_billed_ts": 1481638661,
        "next_billing_ts": 0,
        "renewal_date_ts": 0,
        "free_trial": 0,
        "remain_days": 0,
        "free_trial_over_msg": "Your trial period is over, please subscribe to enjoy Jazz Cricwick services. Package charges PKR 20+Tax/month.",
        "welcome_free_trial": "Welcome to Jazz CricWick, you have been awarded 0 days free trial period."
    },
    "subscribed_streams": [],
    "live_stream_price": 0
}

----------

#### <i class="icon-folder-open"></i> Update GCM Token API

**http://mobisub.cricwick.mobi/main/update_gcm_token?udid=1234udid4321&token=testtoken**

The API updates subscriber `Google Cloud Messenger` (GCM) Token by given Subscriber Device ID (UDID) and return subscriber object in returned response.

<kbd>udid</kbd> and <kbd>token</kbd> are mandatory. the returned response is in <kbd>JSON</kbd> format.

**Update GCM Token :**
>{
    "status": 1,
    "status_message": "user gcm token successfully updates",
    "subscription": {
        "id": 701,
        "phone": "03133139966",
        "pin": null,
        "total_amount": 20,
        "total_days": 30,
        "status": 0,
        "total_installments": 0,
        "succesfull_installments": 0,
        "current_tick": 0,
        "unsub_reason": 1,
        "created_at": "December 13, 2016 11:50",
        "updated_at": "December 13, 2016 11:50",
        "udid": "1234udid4321",
        "next_billing": null,
        "last_billed": "December 13, 2016 14:17",
        "renewal_date": "",
        "reattempt_billing": null,
        "subscription_type": 1,
        "trial_started_at": "2016-12-13T13:24:43.000Z",
        "trial_ended_at": "2016-12-13T14:16:53.000Z",
        "gcm_token": "testtoken",
        "is_postpaid": false,
        "telco_id": 5,
        "last_billed_ts": 1481638661,
        "next_billing_ts": 0,
        "renewal_date_ts": 0
    }
}

----------

#### <i class="icon-hdd"></i> CRON Job (Subscription Scheduled Services)

Look closely what it does ?

```
Subscription.where('telco_id=5 AND (current_tick=1 OR status=1 OR status=2) AND is_postpaid=0').order(id: :desc).each
```
> 0 0,6,12,18  *   *   *     wget http://46.234.109.113/cron/billing -O /dev/null
> 
runs after every 6 hours a day.

>2016-07-30 18:00:00
2016-07-31 00:00:00
2016-07-31 06:00:00
2016-07-31 12:00:00
2016-07-31 18:00:00
2016-08-01 00:00:00
2016-08-01 06:00:00
2016-08-01 12:00:00
2016-08-01 18:00:00
2016-08-02 00:00:00


The cron job runs every 6 hour a day. it first checks for already running job. if so then quit. if not running then the job will list up only `jazz` `prepaid` `active/in-active/trial` subscriber then charge 'em all  and mobilogger save the <i class="icon-edit"></i>**log** to <i class="icon-hdd"></i> **disk file**.

P.S charging job is not applicable in current subscription model.
>0 3,9,15,21  *   *   *     wget http://46.234.109.113/cron/charging -O /dev/null

>4 times a day

----------
**Push Notifications (Active Job):** for sending instant push notification to all user sidedkiq gem is used. it create an array in redis server cache and [<i class="icon-upload"></i> Pushes all subscriber](http://user:cricsub@mobisub.cricwick.mobi/notifications) a notification message.

----------
**Send SMS (Mobilink Users):**

The following URL is used in subscription for sending different messages. i.e PIN, Welcome, Charging SMS, Low Balance e.t.c
>http://mobismpp.vbox.mobi/?user=mobilink_9876&to=03133139966&message=text

----------
**Test Number (Actually won't charge but simulate API):**
Well here are some test number for subscription testing. these number won't bypass API's but simulate Mobilink server response by `1` or `0` without charging user.

| Phone     | Owner | Package   |
| :------- | ----: | :---: |
| 03006568067 | Arslan |  Weekly    |
| 03052251373    | Shiraz   |  N/A   |
| 03004440745     | Rafaqat Sir    |  N/A  |
| 03133139966     | Kamran    |  Monthly  |
| 03054079849     | Kamran    |  N/A  |
| 03001111111     | test    |  N/A  |


----------
