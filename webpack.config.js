const path = require('path');
const webpack = require('webpack');
const LoaderOptionsPlugin = webpack['LoaderOptionsPlugin'];
const merge = require('webpack-merge');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const autoprefixer = require('autoprefixer');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const prod = 'production';
const dev = 'development';

// determine build env
const TARGET_ENV = process.env.npm_lifecycle_event === 'build' ? prod : dev;
const isDev = TARGET_ENV === dev;
const isProd = TARGET_ENV === prod;

// entry and output path/filename variables
const entryPath = path.join(__dirname, 'src/static/index.js');
const mainPath = path.resolve(__dirname, "src/elm/Main.elm");
const outputPath = path.join(__dirname, 'dist');
const outputFilename = isProd ? '[name]-[hash].js' : '[name].js';
const modulesPath = 'node_modules';

console.log('WEBPACK GO! Building for ' + TARGET_ENV);

const postCSSConfig = {
    sourceMap: true,
    plugins() {
        return [
            autoprefixer({})
        ];
    },
};

const postCssLoader = {
    loader: 'postcss-loader',
    options: postCSSConfig
};

// common webpack config (valid for dev and prod)
let commonConfig = {
    mode: isProd ? prod : dev,
    output: {
        path: outputPath,
        chunkFilename: `static/js/${outputFilename}`,
    },
    resolve: {
        extensions: ['.js', '.elm'],
        modules: [modulesPath],
    },
    module: {
        noParse: /\.elm$/,
        rules: [{
            test: /\.(eot|ttf|woff|woff2|svg)$/,
            use: 'file-loader'
        }, {
            test: /\.elm$/,
            exclude: [/elm-stuff/, /node_modules/],
            use: [{
                loader: 'elm-webpack-loader',
                options: {
                    files: [
                        mainPath
                    ],
                    pathToElm: modulesPath + '/.bin/elm',
                    verbose: isDev,
                    debug: isDev,
                    optimize: isProd
                }
            }]
        }]
    },
    plugins: [
        new LoaderOptionsPlugin({
            options: {
                postcss: [autoprefixer()]
            }
        }),
        new HtmlWebpackPlugin({
            template: 'src/static/index.html',
            inject: 'body',
            filename: 'index.html'
        })
    ]
};

// additional webpack settings for local env (when invoked by 'npm start')
if (isDev === true) {
    module.exports = merge(commonConfig, {
        entry: [
            'webpack-dev-server/client?http://localhost:8080',
            entryPath
        ],
        devServer: {
            // serve index.html in place of 404 responses
            historyApiFallback: true,
            contentBase: './src',
            hot: true
        },
        module: {
            rules: [{
                test: /\.sc?ss$/,
                use: [
                    'style-loader',
                    'css-loader',
                    postCssLoader,
                    'sass-loader'
                ]
            }]
        }
    });
}

// additional webpack settings for prod env (when invoked via 'npm run build')
if (isProd === true) {
    module.exports = merge(commonConfig, {
        entry: entryPath,
        module: {
            rules: [{
                test: /\.sc?ss$/,
                use: [
                    MiniCssExtractPlugin.loader,
                    'css-loader',
                    postCssLoader,
                    'sass-loader'
                ]
            }]
        },
        plugins: [
            new MiniCssExtractPlugin(),
            new CopyWebpackPlugin([{
                from: 'src/static/img/',
                to: 'static/img/'
            }, {
                from: 'src/static/favicon.ico'
            }]),

        ],
        optimization: {
            minimize: false,
            splitChunks: {
                chunks: 'all'
            }
        }
        ,
        performance: {
            maxAssetSize: 140000,
            maxEntrypointSize: 256000
        }
    });
}
