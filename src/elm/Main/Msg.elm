module Main.Msg exposing (Msg(..))

import Browser exposing (UrlRequest)
import Components.NavBar
import Post.Pages.Form
import Post.Pages.ListPosts
import Url exposing (Url)


type Msg
    = ListPageMsg Post.Pages.ListPosts.Msg
    | PostFormMsg Post.Pages.Form.Msg
    | NavBarMsg Components.NavBar.Msg
    | LinkClicked UrlRequest
    | UrlChanged Url
