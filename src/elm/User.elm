module Auth.User exposing (..)


type alias User =
    { name : String
    , email : String
    , password : String
    , loggedIn : Bool
    , isGuest : Bool
    }


initialUser : User
initialUser =
    { name = ""
    , email = ""
    , password = ""
    , loggedIn = False
    , isGuest = True
    }
