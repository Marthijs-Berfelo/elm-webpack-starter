// pull in desired CSS/SASS files
require( './styles/main.scss' );

// inject bundled Elm app into div#main
const Elm = require('./../elm/Main.elm').Elm;

const app = Elm.Main.init({
    node: document.getElementById('main')
});
