<template>
<div>
<h1>My Edit</h1>
        <MyPageTab :activeTab="activeTab" />
    <section>
      <ValidationObserver ref="observer" v-slot="{ passes }">
          <EmailInput  v-model="form.email" disabled/>
          <BInputWithValidation
            rules="required|max:25" 
            icon="account"
            placeholder="ユーザー名" 
            vid="password"
            v-model="form.username"
            />
            <b-field label="Select a date">
            <b-datepicker
                @input="hello"
                :date-parser="parseDate"
                :date-formatter="formatDate"
                    :show-week-number="showWeekNumber"
                placeholder="Click to select..."
                icon="calendar-today"
                trap-focus>
            </b-datepicker>
            </b-field>
            <BSelectWithValidation label="性別" v-model="form.gender" placeholder="性別を選択してください">
                <!-- <option value=0>性別を選択してください</option> -->
                <option value=1>男性</option>
                <option value=2>女性</option>
                <option value=3>その他</option>
            </BSelectWithValidation>
            <BInputWithValidation
            rules="max:200" 
            label="自己紹介"
            type="textarea"
            vid="description"
            v-model="form.description"
            />
            <b-icon
                pack="fas"
                icon="tachometer-alt">
            </b-icon>
          <BInputWithValidation
            rules="max:25"  
            icon="twitter"
            placeholder="Twitter id"
            vid="password"
            v-model="form.twitter_id"
            />
            <BInputWithValidation
            icon="facebook"
            placeholder="Facebook id"
            rules="max:25" 
            vid="facebook"
            v-model="form.facebook_id"
            />
              
          <BInputWithValidation
            placeholder="wantedly id"
            rules="max:25"  
            vid="wantedly"
            v-model="form.wantedly_id"
            />
        
          <BInputWithValidation
            placeholder="GitHub id"
            icon="github"
            rules="max:25" 
            vid="github"
            v-model="form.github_id"
            />
         </ValidationObserver>
         
    </section>

    <section>
        <b-field>
             <!-- :data="filteredTags" -->
            <b-taginput
                v-model="form.tags"
               :data="filteredTags"
                autocomplete
                placeholder="保有している技術を追加してください"
                :open-on-focus="openOnFocus"
                field="filteredTags"
                icon="label"
                @input="hey"
                @typing="getFilteredTags">
            </b-taginput>
        </b-field>
        <pre style="max-height: 400px"><b>Tags:</b>{{ form.tags }}</pre>
    </section>
    <button class="button" type="is-dark" @click="UpdateUser">更新</button>
    <!-- {{filteredTags}} -->
</div>
</template>
<script>

import MyPageTab from '~/components/users/MyPageTab.vue'
import EmailInput from '~/components/Form/EmailInput.vue'
import { ValidationObserver, ValidationProvider } from 'vee-validate';
import BInputWithValidation from "~/components/Form/BinputWithValidation.vue";
import BSelectWithValidation from "~/components/Form/BSelectWithValidation.vue";
import ImageUploadWithValidation from '~/components/Form/ImageUploadWithValidation.vue'




export default {
    components: {
        MyPageTab,
        EmailInput,
        ValidationObserver,
        ValidationProvider ,
        BInputWithValidation,
        BSelectWithValidation
    },
    data() {
    return { 
        user : "",
        isModalForm : false,
        FormComponent : "",
        form : {
            email : "",
            username : "",
            gender : "",
            age : "",
            birth : "",
            description : "",
            twitter_id : "",
            facebook_id : "",
            wantedly_id : "",
            github_id : "",
            tags: [],
        },
        filteredTags : [],
        data:[],
        allowNew: false,
        openOnFocus: false,
        showWeekNumber: false,
        activeTab: 1,
        count : 0
    }
    
  },
  watch: {
        filteredTags: function(val) {
            if (val.length === 0){
                this.filteredTags = this.data
            }
        },
         
        form: {
        handler: function (val, oldVal) {
            this.count += 1
            if (this.count > 0) {

            }
        },
        deep: true
      }
    },
    created() {
       this.fetchUser()
       this.FetchCategories()
       
    },

    methods: {
        
        UploadImage(image) {
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            var formData = new FormData();
            formData.append('user[image]', this.form.file );

            if(this.form.file) {
            this.$axios.$put('/api/v1/mypage/user_images',formData,{ 
                headers: {
                    'Content-Type': 'multipart/form-data'
                } 
            })
            .then(response => {
                this.$buefy.toast.open({
                    duration: 5000,
                    message: '画像アップロードが完了しました',
                    type: 'is-success'
                })
                this.$router.push('/users/edit')
                 console.log(response)
            })
            .catch ( error => {
                if (error.response.status == "401" || error.response.status == "500" || error.response.status == "422") {
                    console.log("tokenが無効です")
                        // this.error = "Tokenが無効です"
                    this.$buefy.toast.open({
                        duration: 5000,
                        message: 'サーバー内で問題が発生しました',
                        type: 'is-danger'
                    })
                }
            })
            }
        },
        FetchCategories () {
            this.$axios.$get('/api/v1/fetch_categories')
            .then(res => {
                for (var i = 0;  i < res.tag.length;  i++) {
                    this.filteredTags.push(res.tag[i]["tag_name"]);
                    this.data.push(res.tag[i]["tag_name"]);
                }   
            })
            .catch ( error => {
                if (error.response.status == "401") {
                    console.log("tokenが無効です")
                    this.$buefy.toast.open({
                        duration: 5000,
                        message: 'サーバー内でも問題が発生しました',
                        type: 'is-danger'
                    })
                }
            })
        },
        async fetchUser () {
            await this.$axios.$get('/api/v1/auto_login',{ 
                headers:{
                    "Authorization" :`Bearer ${localStorage.idToken}`
                }
            })
            .then(response => {
                console.log(response)
                this.form.username = response.user.username
                this.form.email = response.user.email
                this.form.age = response.user.age
                this.form.birth = response.user.birth
                this.form.description = response.user.description
                this.form.twitter_id = response.user.twitter_id
                this.form.facebook_id = response.user.facebook_id
                this.form.wantedly_id = response.user.wantedly_id
                this.form.github_id = response.user.github_id
            }) 
        },
        getFilteredTags(text) {
            this.filteredTags = this.filteredTags.filter((option) => {
                return option
                .toString()
                .toLowerCase()
                .indexOf(text.toLowerCase()) >= 0
            })
        },
        async UpdateUser() {
            this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            this.$axios.$put('/api/v1/my_pages/update/',{ 
                user : {
                    username : this.form.username,
                    gender : this.form.gender,
                    age : this.form.age,
                    description : this.form.description,
                    twitter_id : this.form.twitter_id,
                    facebook_id : this.form.facebook_id,
                    wantedly_id : this.form.wantedly_id,
                    github_id : this.form.github_id,
                }
            })
            .then(response => {
                this.$buefy.toast.open({
                    duration: 5000,
                    message: '編集が完了しました',
                    type: 'is-success'
                })
                this.$router.push('/users/mypage')
                 console.log(response)
            })
            .catch ( error => {
                if (error.response.status == "401" || error.response.status == "500" || error.response.status == "422") {
                    console.log("tokenが無効です")
                        // this.error = "Tokenが無効です"
                    this.$buefy.toast.open({
                        duration: 5000,
                        message: 'サーバー内で問題が発生しました',
                        type: 'is-danger'
                    })
                }
            })
        },
        hey () {
            console.log("hey")
            this.filteredTags = this.data
        },
        hello (value) {
            console.log(value)
            this.form.birth = value
        },
        parseDate (date) {
            console.log(date)
        },
        formatDate (date) {
            console.log(date)
        }
    }
}

</script>
