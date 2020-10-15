<template>
<div>
   <!-- {{email}}
  <button @click="user_is_authed()">auth 確認</button>
<button @click="auto_login()">User 情報</button> 
<button @click="logout()">ログアウト</button>  -->
 <section class="section" style="text-align: center;">
     <!-- {{ this.$auth.user.email }}
     {{this.$auth.$state.strategy }} -->
    <main style="top: 50px; position: relative;">
      <h1 class="title is-3">
      <b-icon
        icon="book-open-variant"
        size="is-medium"
      />
      プログラミング学習サービス一覧
      
    </h1>
    {{this.$auth.user}}aa
    <section>
        <b-tabs position="is-centered" @input="StatusSiteCategory" class="block">
            <b-tab-item label="All"></b-tab-item>
            <b-tab-item label="Popular"></b-tab-item>
        </b-tabs>
    </section>
      <div v-for="(site, index) in this.sites" :key="index" style="height: 260px; width:360px; box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 20px 20px; text-align: center; position: relative;">
        <nuxt-link :to="`/sites/${site.id}`">
          <h1 class="title is-6">{{site.title}}</h1>
          <img class="is-rounded" :src="files[index]" alt="Image" style="">
        </nuxt-link>  
        <div>{{site.id}}
         
        </div>
      </div>
     
    </main>
    </section>
  <section class="section" style="text-align: center;">
    <h1 class="title is-4">
      <b-icon
        icon="book-open-variant"
        size="is-medium"
      />
      技術書籍
    </h1>
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
        <div v-for="(tag,index) in this.CategoryTags.slice(0,this.CategoryCount)" :key="index" style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline; margin: 10px 20px; text-align: center;">
            <span style="cursor: pointer;" @click="ChangeCategory(tag.tag_name)"><b-tag>{{tag.tag_name}}</b-tag></span>
          <!-- <img @click="ChangeCategory(tag.tag_name)" :src="tag.icon_url" alt="TOP本"> -->
        </div>  
      </div>
      <a @click="ChangeCategoryCount">
          {{  this.ShowTagCount }}
      </a>
      <div>
        <h1 class="title is-4">書籍一覧</h1>
        <div v-for="(book,index) in this.books" :key="index" style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 20px 20px; text-align: center; position: relative;">
          
          <nuxt-link :to="{name:'books-id',params:{id:book.params.isbn}}">
          <img style="width: 170px; height: 220px;" :src="book.params.largeImageUrl" alt="TOP本"> 
          </nuxt-link>  
          <!-- <span style="position: absolute; left: 0; bottom: -20px; "><b-button type="is-info" size="is-small" @click="PostBookShelf(book.params.isbn,book.params.largeImageUrl)">本棚に登録</b-button></span> -->
        </div>
      </div>
      
    </div>
  </section>
  </div>
 
</template>

<script>
  import Modal from '~/components/Modal.vue'



export default {
  name: 'HomePage',

  components: {
    Modal
  },
  data() {
    return {
    email : "",
    error: "",
    isModalForm : false,
    FormComponent : "",
    books : "",
    CategoryTags : [],
    CategoryCount : 30,
    IsCategoryTag : false,
    ShowTagCount : "More ...",
    sites : "",
    files : null,
    CheckUserLike : false
    }
  },



  mounted() {

    // console.log(this.$auth.user)
    },

    created () {
      // this.Auth()
      this.FetchSites()
      this.FetchCategories()
      this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
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
      this.$axios.$post('/api/v1/token_check',{
      token : this.$route.query.token
    })
    .then(res => {
      this.email = res.email
      console.log(res.email)  
      console.log(this.email)
    if(this.$auth.loggedIn === false) {
      this.login()
      this.$router.push('/')
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
  StatusSiteCategory(status) {
    if (status === 0) {
      this.FetchSites()
    } else if (status == 1) {
      this.FetchSiteRank()
    }
            console.log(status)
        },
  // /api/v1/favorite_rank
  FetchSiteRank () {
            // this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            this.$axios.$get('/api/v1/site_rank')
            .then(res => {
                  console.log(res)
              this.sites = res.data
              this.files = res.images
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
    async login() {
      await this.$auth.loginWith('user',{
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
      console.log(process.env.BASE_URL)
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
      this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
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

    ChangeCategoryCount () {
    switch (this.CategoryCount) {
      case 30:
        this.CategoryCount = 100
        this.IsCategoryTag = true
        break;
      case 100:
        this.CategoryCount = 200
        break;
      case 200:
        this.CategoryCount = 300
        break;
      case 300:
        this.CategoryCount = 400
        this.ShowTagCount = "Close ..."
        break;
      case 400:
        this.CategoryCount = 30
        this.IsCategoryTag = false
        this.ShowTagCount = "More ..."
        window.scrollTo({
          top: 0,
          behavior: "smooth"
        });   
        break;
    }
            

    },
    FetchSites () {
            this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`
            this.$axios.$get('/api/v1/sites')
            .then(res => {
           
             this.sites = res.data
             this.files = res.images

            //  this.skill_tags = [[7,"iOS",1], [9,"Android",2]]
             console.log(res)
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
    PostSiteFavorite (id) {
      console.log("hey")
this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
     this.$axios.$post(`/api/v1/sites/${id}/site_favorites`, {
        // site_favorites : {
        //   isbn : lsbn,
        //   imageurl : imageurl
        // }
     })
      .then(res => {
        console.log(res.data)
        this.IsFavorite = true
        this.$buefy.toast.open({
            duration: 1000,
            message: 'お気に入り登録しました',
            type: 'is-info'
          })
        })
    .catch ( error => {
      if (error.response.status == "401") {
          this.$buefy.toast.open({
            duration: 5000,
            message: 'サーバー内でも問題が発生しました',
            type: 'is-danger'
          })
      }
    })
    },
    
    //   Auth () {
    //     if(this.$auth.$state.strategy && this.$auth.loggedIn && !localStorage.idToken && !this.$route.query.token) {
    //       console.log("heyhey")
    //       console.log(localStorage.auth_status)

          
    //     this.$axios.$post('/api/v1/login', {
          
    //         email : this.$auth.user.email,
    //         provider : this.$auth.$state.strategy,
    //         auth_status: localStorage.auth_status
         
         
    //     }
        
    //     )
    //     .then(res => {   
    //         // console.log(res.tag)  
    //         console.log(res.token)  
    //         localStorage.setItem('idToken',res.token)           
    //         })
    //         .catch ( error => {
    //             if (error.response.status == "401") {
    //                 console.log("tokenが無効です")
    //                 this.$buefy.toast.open({
    //                     duration: 5000,
    //                     message: 'サーバー内でも問題が発生しました',
    //                     type: 'is-danger'
    //                 })
    //             } else if (error.response.status == "422") {
    //               this.$auth.logout();
    //               localStorage.clear()
    //               console.log(error.response)
    //               this.$buefy.toast.open({
    //                     duration: 5000,
    //                     message: error.response.data.validation,
    //                     type: 'is-danger'
    //                 })
    //             }
    //     })
    //     }
    // },
    // PostBookShelf(lsbn,imageurl) {
    //  console.log(lsbn)
    //  console.log(imageurl)
    //  this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
    //  this.$axios.$post('/api/v1/book/bookshelves', {
    //    bookshelf : {
    //      lsbn : lsbn,
    //      imageurl : imageurl
    //    }

    //  })
    //   .then(res => {
    //     console.log(res)
     
    //     })
    // .catch ( error => {
    //   if (error.response.status == "401") {
    //       console.log("tokenが無効です")
    //       // this.error = "Tokenが無効です"
    //       this.$buefy.toast.open({
    //         duration: 5000,
    //         message: 'サーバー内でも問題が発生しました',
    //         type: 'is-danger'
    //       })
         

    //   }
    //     })
     
    // }
    
}

}
</script>

// /api/v1/book/bookshelves