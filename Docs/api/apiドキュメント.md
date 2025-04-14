# APIドキュメント


## ドキュメントの構成

### ユーザー関係
- [ユーザー登録](#ユーザー登録)
- [ログイン](#ログイン)
- [ユーザー情報取得](#ユーザー情報取得)
- [アイコン画像登録](#アイコン画像登録)
- [アイコン画像取得](#アイコン画像取得)

### 投稿関係

- [投稿](#投稿)
- [投稿取得](#投稿取得)
    - [Publicのみ](#Publicのみ)
    - [ユーザーID指定](#ユーザーID指定)
    - [フレンドのみ](#フレンドのみ)
    - [マップ用](#マップ用)
    - [タイムライン用](#タイムライン用)
- [投稿削除](#投稿削除)


### フレンド関係
- [フレンド登録](#フレンド登録)
- [フレンド取得](#フレンド取得)
- [フレンド削除](#フレンド削除)



## ユーザー登録

### リクエスト

```ts
POST /api/resister
```

### リクエストボディ

```json
{
    "name": string,
    "email": string,
    "password": string
}
```

### レスポンス

```json
{
    "name": string,
    "userId": string,
    "email": string
}
```

リクエストの本体には、ユーザー名、メールアドレス、パスワードを含める必要があります。

成功した場合、レスポンスの本体には、ユーザー名、ユーザーID、メールアドレスが含まれます。それぞれ、本体のUserDefaultに格納されています。

## ログイン    

### リクエスト

```ts
POST /api/login
```

### リクエストボディ

```json
{
    "email": string,
    "password": string
}
```

### レスポンス

```json
{
    "name": string,
    "userId": string,
    "email": string,
    "iconKey": string
}
```

リクエストの本体には、メールアドレス、パスワードを含める必要があります。

成功した場合、レスポンスの本体には、ユーザー名、ユーザーID、メールアドレス、アイコン画像のキーが含まれます。それぞれ、本体のUserDefaultに格納されています。

## ユーザー情報取得

### リクエスト

```ts
GET /api/user?userId={userId}
```

### レスポンス

```json
{
    "name": string,
    "userId": string,
    "email": string,
    "iconKey": string,
    "numOfPosts": number,
    "numOfFriends": number,
}
```

リクエストのクエリには、ユーザーIDを含める必要があります。レスポンスの本体には、ユーザー名、ユーザーID、メールアドレス、アイコン画像のキー、投稿数、フレンド数が含まれます。

## アイコン画像登録

### リクエスト

```ts
PUT /api/user/icon
```

### リクエストボディ

```json
{
    "userId": string,
    "key": string
}
```

### レスポンス

```json
{
    "userId": string,
    "iconKey": string
}
```

リクエストの本体には、ユーザーID、アイコン画像をbase64でエンコードした文字列を含める必要があります。

成功した場合、レスポンスの本体には、ユーザーID、アイコン画像のキーが含まれます。それぞれ、本体のUserDefaultに格納されています。

## アイコン画像取得

### リクエスト

```ts
GET /api/user/icon?userId={userId}
```

### レスポンス

画像ファイル

リクエストのクエリには、ユーザーIDを含める必要があります。レスポンスの本体には、アイコン画像が含まれます。

## 投稿

### リクエスト

```ts
PUT /api/post
```

### リクエストボディ

```json
{
    "userId": string,
    "userName": string,
    "key": string,
    "title": string,
    "latitude": number,
    "longitude": number,
    "createdAt": string,
    "isPublic": boolean,
    "isFriendsOnly": boolean,
    "isPrivate": boolean
}
```

### レスポンス

```json
{
    "Id": string,
    "userId": string,
    "userName": string,
    "key": string,
    "title": string,
    "latitude": number,
    "longitude": number,
    "createdAt": string,
    "isPublic": boolean,
    "isFriendsOnly": boolean,
    "isPrivate": boolean
}
```

リクエストの本体には、ユーザーID、ユーザー名、投稿画像をbase64でエンコードした文字列、タイトル、緯度、経度、投稿日時、公開範囲を含める必要があります。

成功した場合、レスポンスの本体には、投稿ID、ユーザーID、ユーザー名、投稿画像のキー、タイトル、緯度、経度、投稿日時、公開範囲が含まれます。これは、本体のSwiftDataのMyPostsに格納されます。


## 投稿取得
- [Publicのみ](#Publicのみ)
- [ユーザーID指定](#ユーザーID指定)
- [フレンドのみ](#フレンドのみ)
- [マップ用](#マップ用)
- [タイムライン用](#タイムライン用)

## Publicのみ

### リクエスト

```ts
GET /api/posts/all
```

### レスポンス

```json
[
    {
        "Id": string,
        "userId": string,
        "userName": string,
        "key": string,
        "title": string,
        "latitude": number,
        "longitude": number,
        "createdAt": string,
        "isPublic": boolean,
        "isFriendsOnly": boolean,
        "isPrivate": boolean
    },
    ...
]
```

レスポンスの本体には、isPublicがtrueである投稿ID、ユーザーID、ユーザー名、投稿画像のキー、タイトル、緯度、経度、投稿日時、公開範囲が含まれます。



## ユーザーID指定

### リクエスト

```ts
GET /api/posts/user?userId={userId}
```

### レスポンス

```json
[
    {
        "Id": string,
        "userId": string,
        "userName": string,
        "key": string,
        "title": string,
        "latitude": number,
        "longitude": number,
        "createdAt": string,
        "isPublic": boolean,
        "isFriendsOnly": boolean,
        "isPrivate": boolean
    },
    ...
]
```

リクエストのクエリには、ユーザーIDを含める必要があります。レスポンスの本体には、ユーザーIDが一致する投稿ID、ユーザーID、ユーザー名、投稿画像のキー、タイトル、緯度、経度、投稿日時、公開範囲が含まれます。



## フレンドのみ

### リクエスト

```ts
GET /api/posts/friends?userId={userId}?friendId={friendId}
```

### レスポンス

```json
[
    {
        "Id": string,
        "userId": string,
        "userName": string,
        "key": string,
        "title": string,
        "latitude": number,
        "longitude": number,
        "createdAt": string,
        "isPublic": boolean,
        "isFriendsOnly": boolean,
        "isPrivate": boolean
    },
    ...
]
```

リクエストのクエリには、ユーザーID、フレンドIDを含める必要があります。レスポンスの本体には、フレンドの``isFriendsOnly=true``もしくは``isPublic=true``である投稿の投稿ID、ユーザーID、ユーザー名、投稿画像のキー、タイトル、緯度、経度、投稿日時、公開範囲が含まれます。

## マップ用

### リクエスト

```ts
GET /api/posts/area?latitude={latitude}&longitude={longitude}&latitudeDelta={latitudeDelta}&longitudeDelta={longitudeDelta}&userId={userId}
```

### レスポンス

```json
[
    {
        "Id": string,
        "userId": string,
        "userName": string,
        "key": string,
        "title": string,
        "latitude": number,
        "longitude": number,
        "createdAt": string,
        "isPublic": boolean,
        "isFriendsOnly": boolean,
        "isPrivate": boolean
    },
    ...
]
```

リクエストのクエリには、緯度、経度、緯度の範囲、経度の範囲を含める必要があります。レスポンスの本体には、指定した範囲内にある自分の投稿以外の``isPublic=true`` の投稿ID、ユーザーID、ユーザー名、投稿画像のキー、タイトル、緯度、経度、投稿日時、公開範囲が含まれます。

## タイムライン用

### リクエスト

```ts
GET /api/posts/location?latitude={latitude}&longitude={longitude}
```

### レスポンス

```json
[
    {
        "Id": string,
        "userId": string,
        "userName": string,
        "key": string,
        "title": string,
        "latitude": number,
        "longitude": number,
        "createdAt": string,
        "isPublic": boolean,
        "isFriendsOnly": boolean,
        "isPrivate": boolean
    },
    ...
]
```

リクエストのクエリには、現在地の緯度、経度を含める必要があります。レスポンスの本体には、現在地を中心にして、400m四方にある``isPublic=true``の投稿ID、ユーザーID、ユーザー名、投稿画像のキー、タイトル、緯度、経度、投稿日時、公開範囲が含まれます。


## 投稿削除

### リクエスト

```ts
DELETE /api/post?postId={postId}
```

### レスポンス

```json
{
    "deleted": boolea,
    "Id": string
}
```

リクエストのクエリには、削除する投稿IDを含める必要があります。レスポンスの本体には、削除した投稿ID、削除が成功したかどうかが含まれます。


## フレンド登録

### リクエスト

```ts
POST /api/friends/add
```

### リクエストボディ

```json
{
    "userId": string,
    "friendId": string
}
```

### レスポンス

```json
{
    "userId": string,
    "friendId": string,
    "status": string
}
```

リクエストの本体には、ユーザーID、フレンドIDを含める必要があります。

成功した場合、レスポンスの本体には、ユーザーID、フレンドID、フレンド申請の状態(`pendin` or `accepted`)が含まれます。

## フレンド取得

### リクエスト

```ts
GET /api/friends?userId={userId}
```

### レスポンス

```json
[
    {
        "friendId": string,
        "userName": string,
        "iconKey": string,
    },
    ...
]
```

リクエストのクエリには、ユーザーIDを含める必要があります。レスポンスの本体には、ユーザーIDが一致するフレンドID、ユーザー名、アイコン画像のキーが含まれます。

## フレンド削除

### リクエスト

```ts
DELETE /api/friends/delete?userId={userId}&friendId={friendId}
```

### レスポンス

```json
{
    "deleted": boolean,
    "userId": string,
    "friendId": string
}
```

リクエストのクエリには、ユーザーID、フレンドIDを含める必要があります。レスポンスの本体には、削除したフレンドID、削除が成功したかどうかが含まれます。



