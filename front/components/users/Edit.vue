<template>
<div>
    <h1>Edit</h1>
    <section>
         <EmailInput v-model="email"/>
         <b-field label="ユーザー名">
            <b-input v-model="username"></b-input>
        </b-field>
         <b-field label="性別" v-model="gender">
            <b-select placeholder="性別"> 
                <option disabled value="">性別を選択してください</option>
                <option value=1>男性</option>
                <option value=2>女性</option>
                <option value=3>その他</option>
            </b-select>
        </b-field>
        <b-field label="年齢" v-model="age">
            <b-select placeholder="年齢"> 
                <option disabled value="">性別を選択してください</option>
                <option value=1>1</option>
                <option value=2></option>
                <option value=3>その他</option>
            </b-select>
        </b-field>
        <b-field label="自己紹介"  v-model="description">
            <b-input maxlength="200" type="textarea"></b-input>
        </b-field>
        <b-field label="Twitterアカウント">
            <b-input v-model="twitter_id"></b-input>
        </b-field>
        <b-field label="Facebookアカウント">
            <b-input v-model="facebook_id"></b-input>
        </b-field>
        <b-field label="Wantedlyアカウント">
            <b-input v-model="wantedly_id"></b-input>
        </b-field>
        <b-field label="GiHubアカウント">
            <b-input v-model="github_id"></b-input>
        </b-field>
    </section>

    <section>
    
        <b-field label="Enter some tags">
             <!-- :data="filteredTags" -->
            <b-taginput
                v-model="tags"
               :data="filteredTags"
                autocomplete
                :allow-new="allowNew"
                :open-on-focus="openOnFocus"
                field="filteredTags"
                icon="label"
                placeholder="Add a tag"
                @typing="getFilteredTags">
            </b-taginput>
        </b-field>
        <pre style="max-height: 400px"><b>Tags:</b>{{ tags }}</pre>
    </section>
    {{filteredTags}}
    email  *String Not NULL,UNIQUE,MAX=25*
*  username, *String,Not null,UNIQUE,MAX=25*
* gender *TinyInt*
* age*TinyInt*
* description *text*
* twitter_id *String,MAX=40*
* facebook_id*String,MAX=40*
* wantedly_id*String,MAX=40*
* github_id*String,MAX=40*
* *image* *String,MAX=120*
* login_token*String,MAX=120*
* login_token_valid_until*String,MAX=120*

   
</div>
</template>

<script>
import EmailInput from '~/components/Form/EmailInput.vue'
     import { ValidationObserver, ValidationProvider } from 'vee-validate';


export default {
    components: {
            EmailInput,
            ValidationObserver,
            ValidationProvider  
        },
       
  data() {
    return {
    email : "",
    username : "",
    gender : "",
    age : "",
    description : "",
    twitter_id : "",
    facebook_id : "",
    wantedly_id : "",
    github_id : "",
    filteredTags : [],
    tags: [],
    allowNew: false,
    openOnFocus: false


    }
  },
   created() {
       this.fetchUser()
       this.FetchCategories()
    },
    methods: {
        FetchCategories () {
            this.$axios.$get('http://127.0.0.1:3000/api/v1/fetch_categories')
      .then(res => {
        for (var i = 0;  i < res.tag.length;  i++){
            this.filteredTags.push(res.tag[i]["tag_name"]);
        }
        
    //   this.filteredTags = res.tag
        })
    .catch ( error => {
      if (error.response.status == "401") {
          console.log("tokenが無効です")
          // this.error = "Tokenが無効です"
          this.$buefy.toast.open({
            duration: 5000,
            message: 'サーバー内でも問題が発生しました',
            type: 'is-danger'
          })
         
      }
        })
        },
        // ユーザー情報取得
        async fetchUser () {
            const ret = await this.$axios.$get('/api/v1/auto_login',{ 
                headers:{"Authorization" :`Bearer ${localStorage.idToken}`
                }
             })
             .then(res => {
                 console.log(res)
                 this.email = res.email
             }) 
             
        },

         getFilteredTags(text) {
                this.filteredTags = this.filteredTags.filter((option) => {
                    console.log(option)
                    return option
                        .toString()
                        .toLowerCase()
                        .indexOf(text.toLowerCase()) >= 0
                        
                        
                
                })
                this.filteredTags = []
                console.log(this.filteredTags)
                this.FetchCategories()
            }
    }
    
}

</script>