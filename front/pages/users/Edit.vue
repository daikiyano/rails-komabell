<template>
<div>

    <h1>My Edit</h1>
        <MyPageTab :activeTab="activeTab" />
     <h1>Edit</h1>
    <section>
         <EmailInput  v-model="form.email"/>
         <b-field label="ユーザー名">
            <b-input v-model="form.username"></b-input>
        </b-field>
         <b-field label="性別" v-model="form.gender">
            <b-select placeholder="性別"> 
                <option disabled value="">性別を選択してください</option>
                <option value=1>男性</option>
                <option value=2>女性</option>
                <option value=3>その他</option>
            </b-select>
        </b-field>
        
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
        <b-field label="自己紹介">
            <b-input maxlength="200" type="textarea" v-model="form.description"></b-input>
        </b-field>
        <b-field label="Twitterアカウント">
            <b-input v-model="form.twitter_id"></b-input>
        </b-field>
        <b-field label="Facebookアカウント">
            <b-input v-model="form.facebook_id"></b-input>
        </b-field>
        <b-field label="Wantedlyアカウント">
            <b-input v-model="form.wantedly_id"></b-input>
        </b-field>
        <b-field label="GiHubアカウント">
            <b-input v-model="form.github_id"></b-input>
        </b-field>
    </section>

    <section>
    
        <b-field label="Enter some tags">
             <!-- :data="filteredTags" -->
            <b-taginput
                v-model="form.tags"
               :data="filteredTags"
                autocomplete
                :open-on-focus="openOnFocus"
                field="filteredTags"
                icon="label"
                @input="hey"
                placeholder="Add a tag"
                @typing="getFilteredTags">
            </b-taginput>
        </b-field>
        <pre style="max-height: 400px"><b>Tags:</b>{{ form.tags }}</pre>
    </section>
    <button class="button" type="is-dark" @click="UpdateUser">更新</button>
    <!-- {{filteredTags}} -->
    <br>
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
import MyPageTab from '~/components/users/MyPageTab.vue'
import EmailInput from '~/components/Form/EmailInput.vue'
import { ValidationObserver, ValidationProvider } from 'vee-validate';



export default {
    components: {
        MyPageTab,
        EmailInput,
        ValidationObserver,
        ValidationProvider 
    },
    data() {
    return {
        user : "",
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
    }
    
  },
  watch: {
        filteredTags: function(val) {
            if (val.length === 0){
                this.filteredTags = this.data
            }
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
                for (var i = 0;  i < res.tag.length;  i++) {
                    this.filteredTags.push(res.tag[i]["tag_name"]);
                    this.data.push(res.tag[i]["tag_name"]);
                }   
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
    async fetchUser () {
            const ret = await this.$axios.$get('/api/v1/auto_login',{ 
                headers:{"Authorization" :`Bearer ${localStorage.idToken}`
                }
             })
             .then(res => {
                 console.log(res)
                 this.form.username = res.username
                 this.form.email = res.email
                 this.form.age = res.age
                 this.form.birth = res.birth
                 this.form.description = res.description
                 this.form.twitter_id = res.twitter_id
                 this.form.facebook_id = res.facebook_id
                 this.form.wantedly_id = res.wantedly_id
                 this.form.github_id = res.github_id
                //  this.form.tags = res.
           
             }) 
             
        },

         getFilteredTags(text) {
                this.filteredTags = this.filteredTags.filter((option) => {
                    // console.log(option)
                    return option
                        .toString()
                        .toLowerCase()
                        .indexOf(text.toLowerCase()) >= 0
                     
                
                })
                
                // console.log(this.filteredTags)
                
                // this.FetchCategories()
            },
            async UpdateUser() {
            console.log("UpdateUser")
            // await this.$axios.$get('/api/v1/auto_login',{ 
            //     headers: {
            //         "Authorization" :`Bearer ${localStorage.idToken}`,
            //         "Content-Type": "application/json"
            //     } 
            //  })
            //  .then(res => {
                this.$axios.$put(`/api/v1/my_pages/update/${res.id}`,{ 
                    headers: {
                    "Authorization" :`Bearer ${localStorage.idToken}`,
                    "Content-Type": "application/json"
                } ,
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
                this.$buefy.toast.open({
                    duration: 5000,
                    message: '編集が完了しました',
                    type: 'is-success'
                })
                this.$router.push('/users/mypage')


            //  }) 
            //  .then(response => {
            //      console.log(this.form)
            //      console.log(response)
            //  })
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
