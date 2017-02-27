/* global Vue */

// var App = require('./app.vue');
// $(function() {
// 	App.$mount('#app');
// });

// import Vue from 'vue';
// import App from './app.vue';

import Vue from "vue";
import VueFormGenerator from "../../src";
Vue.use(VueFormGenerator);

import App from './app.vue';

new Vue({
    ...App
}).$mount('#app');