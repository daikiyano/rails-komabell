<template>
<div>
   <!-- {{email}}
  <button @click="user_is_authed()">auth 確認</button>
<button @click="auto_login()">User 情報</button> 
<button @click="logout()">ログアウト</button>  -->
  <section class="section" style="text-align: center;">
    <h1>技術書籍</h1>
    <div class="columns is-mobile">
    <Modal :isModalForm="this.isModalForm" 
          :FormComponent="this.FormComponent"   
          @isCloseModal="closeModal" 
          @ChangeForm="ChangeForm($event)" 
    />
    </div>
    <div>
      <h1>技術カテゴリ</h1>
      <div style="background-color: white;">
        <div v-for="(tag,index) in this.CategoryTags.slice(0,30)" :key="index" style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline; margin: 10px 20px; text-align: center;">
            <span style="cursor: pointer;" @click="ChangeCategory(tag.tag_name)"><b-tag>{{tag.tag_name}}</b-tag></span>
          <!-- <img @click="ChangeCategory(tag.tag_name)" :src="tag.icon_url" alt="TOP本"> -->
        </div>
        
      </div>
      <b-button type="is-dark">技術カテゴリ一覧を見る</b-button>
      <div>
        <h1>書籍一覧</h1>
        <div v-for="(book,index) in this.books" :key="index" style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 20px 20px; text-align: center; position: relative;">
          
          <nuxt-link :to="{name:'books-id',params:{id:book.params.isbn}}">
          <img style="width: 170px; height: 220px;" :src="book.params.largeImageUrl" alt="TOP本"> 
          </nuxt-link>  
          <span style="position: absolute; left: 0; bottom: -20px; "><b-button type="is-info" size="is-small" @click="PostBookShelf(book.params.isbn,book.params.largeImageUrl)">本棚に登録</b-button></span>
          
        </div>
      </div>
      <star-rating v-bind:increment="0.5"
             v-bind:max-rating="3"
             inactive-color="#000"
             active-color="#f00"
             v-bind:star-size="90">
</star-rating>
    </div>
  </section>
  </div>
 
</template>

<script>
  import Modal from '~/components/Modal.vue'
  import StarRating from 'vue-star-rating'



export default {
  name: 'HomePage',
  components: {
        Modal,
        StarRating
        },
  data() {
    return {
    email : "",
    error: "",
    isModalForm : false,
    FormComponent : "",
    books : "",
    CategoryTags : []
    }
  },

    created () {
      this.FetchCategories()

      this.$axios.$get('/api/v1/search/001005')
      .then(res => {
        this.books = ""
        console.log(res.tag)
      this.books = res.data
      this.tags = res.tag
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
      

    if (this.$route.query.token) {
      this.$axios.$post('http://127.0.0.1:3000/api/v1/token_check',{
      token : this.$route.query.token
    })
    .then(res => {
      this.email = res.email
      console.log(res.email)  
      console.log(this.email)
    if(this.$auth.loggedIn === false) {
      this.login()
      this.$buefy.toast.open({
        duration: 5000,
        message: 'ようこそ！！',
        type: 'is-success'
      })
    }
    })
    .catch ( error => {
      if (error.response.status == "401") {
          console.log("tokenが無効です")
          // this.error = "Tokenが無効です"
          this.$buefy.toast.open({
            duration: 5000,
            message: 'トークンが無効です',
            type: 'is-danger'
          })
          this.isModalForm = true
          this.FormComponent = "Login"

      }
        })
    }
    },

methods: {
    async login() {
      await this.$auth.loginWith('local',{
        data: {
              email: this.email
          }
        
        }).then((response) => {
          console.log(response.data.token)
          localStorage.setItem('idToken',response.data.token)
          console.log(response)
        },
        (error) => {
          console.log(error)
        })
        
      
    },
    logout() {
      this.$auth.logout();
      localStorage.clear()
      console.log(this.$auth.loggedIn)
    },
    closeModal () {
      this.isModalForm = false
    },
    ChangeForm(FormComponent) {
      console.log(FormComponent)
      this.FormComponent = FormComponent
    },
    FetchCategories () {
        this.$axios.$get('/api/v1/fetch_categories')
        .then(res => {   
            console.log(res.tag)             
                this.CategoryTags = res.tag      
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
    ChangeCategory (TagName) {
      console.log(TagName)
      this.$axios.$get(`/api/v1/search/${TagName}`)
      .then(res => {
        this.books = ""
        this.books = res.data
        console.log(res.data)
        console.log(TagName)
     
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
    PostBookShelf(lsbn,imageurl) {
     console.log(lsbn)
     console.log(imageurl)
     this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
     this.$axios.$post('/api/v1/book/bookshelves', {
       bookshelf : {
         lsbn : lsbn,
         imageurl : imageurl
       }

     })
      .then(res => {
        console.log(res)
     
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
     
    }
    
}

}
</script>

// /api/v1/book/bookshelves