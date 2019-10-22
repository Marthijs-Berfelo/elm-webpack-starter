// pull in desired CSS/SASS files
require( './styles/main.scss' );

const $ = jQuery = require( '../../node_modules/jquery/dist/jquery.min.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );         // <--- remove if Bootstrap's JS not needed

// inject bundled Elm app into div#main
const Elm = require('./../elm/Main.elm').Elm;

const app = Elm.Main.init({
    node: document.getElementById('main')
});
