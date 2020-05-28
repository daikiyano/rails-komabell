import Vue from 'vue'
import {
  extend,
  ValidationProvider,
  ValidationObserver,
  localize
} from 'vee-validate'
import ja from 'vee-validate/dist/locale/ja.json'
import * as originalRules from 'vee-validate/dist/rules';
import { required, email, max } from 'vee-validate/dist/rules'

// extend('email', email)
extend('max', {
  ...max,
  message: '文字数が超過しているようです。ご確認の上、文字数制限内に収めてみてください。'
})
extend('required', required)

extend('email',{
  ...email,
  message: 'メールアドレスは有効ではありません'
})


let rule;
for (rule in originalRules) {
  extend(rule, {
    ...originalRules[rule], // eslint-disable-line
  });
}

Vue.component('validation-provider', ValidationProvider)
Vue.component('validation-observer', ValidationObserver)

localize('ja', ja)
// Vue.use(validate)
