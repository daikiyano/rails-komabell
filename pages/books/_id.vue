<template>
  <div>
    <main style="top: 50px; position: relative;">
      <h1 class="title is-3">{{books.title}}</h1>
      <div class="tile is-ancestor">
        <article class="media box">
          <div class="media-left">
            <img :src="books.largeImageUrl" alt="TOP本" style="display: block;"> 
          </div>
          <div class="media-content">
            <div class="content">
              <p> 
                <strong>著者:　{{books.author}}</strong><br>
                <strong>出版社:　{{books.publisherName}}</strong><br>
                <star-rating v-bind:increment="0.5"
                  v-bind:max-rating="5"
                  v-bind:show-rating="false"
                  v-bind:star-size="30">
                </star-rating>
                {{books.itemCaption}} <br>
                <span v-if="IsBookshelf === false" style="position: relative; "><b-button type="is-info" @click="PostBookShelf(books.isbn,books.largeImageUrl)">本棚に登録</b-button></span>
                <span v-if="IsBookshelf === true" style="position: relative; "><b-button type="is-light" @click="DeleteBookShelf(books.isbn,books.largeImageUrl)">本棚から外す</b-button></span>
                <span v-if="!this.$auth.loggedIn" style="position: relative; "><b-button type="is-light" @click="isModalForm=true; FormComponent='Login'; LoginPop()">本棚に登録</b-button></span>
                <a :href='books.affiliateUrl'>
                  <b-button type="is-success" outlined>本の詳細を確認</b-button>
                </a>      
              </p>
            </div>
          </div> 
        </article>
      </div>
      <h1 class="title is-5">{{books.title}} のレビュ一覧</h1>
      <div v-if="comments.length > 0">
        <div v-for="(comment, index) in this.comments" :key="index">
          <article class="media">
            <div class="media-left">
              <p class="image is-64x64">
                <img class="is-rounded" :src="images[index]" alt="Image">
              </p>
            </div>
            <div class="media-content">
              <div class="content">
                <p>
                  <strong>
                    @{{comment.username}}
                  </strong>
                  <br>
                  {{comment.comment}} {{comment.id}}<br>
                  {{ $moment(comment.created_at).fromNow() }}
                  <span @click="DeleteBookComment(comment.id,user.id)">
                  <b-icon v-if="comment.user_id === user.id" icon="trash-can-outline" size="is-small"></b-icon>
                  </span>
                </p>
                </div>
            </div>
          </article>  
        </div>
      </div>
      <div v-else style="height: 400px;">
        <h1 class="title is-6" style="text-align: center; padding-top: 100px;">レビューコメントはありません</h1>
      </div>
      <div v-if="this.$auth.loggedIn" style="width: 100%; height: 400px;">
        <b-field label="評価コメント">
          <b-input v-model="comment" maxlength="200" type="textarea"></b-input>
        </b-field>
        <b-field label="評価">
          <star-rating 
            @rating-selected="setRating"
            v-bind:increment="0.5"
            v-bind:max-rating="5"
            v-bind:show-rating="false"
            v-bind:star-size="30">
          </star-rating>
        </b-field>
        <span>{{ErrorMessage}}</span><br>
          <b-button type="is-light" size="is-small" @click="PostBookComment(books.isbn)">コメントする</b-button>
      </div>
    </main>
    <Modal :isModalForm="this.isModalForm" 
      :FormComponent="this.FormComponent"   
      @isCloseModal="closeModal" 
      @ChangeForm="ChangeForm($event)" 
      />
  </div>
</template>

<script>
import Login from '~/components/Login.vue'
  import SignUp from '~/components/SignUp.vue'
  import Modal from '~/components/Modal.vue'
  import StarRating from 'vue-star-rating'

  var moment = require('moment-timezone');

 export default {
    components: {
      StarRating,
      Login,
      SignUp,
      Modal
    },
    data() {
      return {
        books : "",
        IsBookshelf : null,
        comment : "",
        rating : null,
        ErrorMessage : "",
        comments : {},
        images : [],
        user : null,
        isModalForm : false,
        FormComponent : ""
      }
    },
    created () {
      this.test()
      this.FetchBookComment()
      this.fetchUser()
    },
  methods: {
    test () {
      const isbn = this.$route.params.id
      this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
      this.$axios.$get(`/api/v1/books/${isbn}`)
      .then(res => {
        console.log(res)
        console.log(res.data[0].params)
        this.books = res.data[0].params
        this.IsBookshelf = res.IsBookshelf

        })
    .catch ( error => {
      if (error.response.status == "404") {
          console.log("書籍が見つかりません")
          this.$buefy.toast.open({
            duration: 5000,
            message: '書籍が見つかりません',
            type: 'is-danger'
          })
      }
    })
    },
    FetchBookComment () {
      const isbn = this.$route.params.id
      this.$axios.$get(`/api/v1/book/book_comments/${isbn}`)
      .then(res => {
        console.log(res.data)
        console.log("hey")
        this.comments = res.data
        this.images = res.images


        })
    .catch ( error => {
      if (error.response.status == "404") {
          console.log("書籍が見つかりません")
          this.$buefy.toast.open({
            duration: 5000,
            message: '書籍が見つかりません',
            type: 'is-danger'
          })
      }
    })
      
    },
    DeleteBookComment(comment_id,user_id) {
      console.log(`comment_id : ${comment_id}`)
      this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
     this.$axios.$delete(`/api/v1/book/book_comments/${comment_id}`)
      .then(res => {
        console.log(res)
        this.$buefy.toast.open({
            duration: 1000,
            message: 'コメントを削除しました',
            type: 'is-info'
          })
        })
    .catch ( error => {
      if (error.response.status == "401") {
        this.$buefy.toast.open({
          duration: 5000,
          message: 'サーバー内で問題が発生しました',
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
         isbn : lsbn,
         imageurl : imageurl
       }
     })
      .then(res => {
        console.log(res)
        this.IsBookshelf = res.IsBookshelf
        this.$buefy.toast.open({
            duration: 1000,
            message: '本棚に登録しました',
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
    DeleteBookShelf(isbn,imageurl) {
     console.log(isbn)
     console.log(imageurl)
     const params = new URLSearchParams();
     params.append('bookshelf[isbn]',isbn)
     this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
     this.$axios.$delete('/api/v1/book/bookshelves', { data: params })
      .then(res => {
        console.log(res.IsBookshelf)
        this.IsBookshelf = res.IsBookshelf
        this.$buefy.toast.open({
            duration: 1000,
            message: '本棚から外しました',
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
    PostBookComment(isbn) {
      
      if(this.comment && this.rating) {
        this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}` 
        this.$axios.$post('/api/v1/book/book_comments', {
        book_comment : {
          isbn : isbn,
          comment : this.comment
        }
      })
        .then(res => {
          console.log(res)
          console.log(res.data)
          this.comments.push(res.data);
          this.$buefy.toast.open({
              duration: 1000,
              message: '本棚に登録しました',
              type: 'is-info'
            })
            // this.$router.push(`/books/${res}`)
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
      } else {
        this.ErrorMessage = "コメントと評価を入力してください"
      } 
      },
    async fetchUser () {
      if (localStorage.idToken) {
        const ret = await this.$axios.$get('/api/v1/auto_login',{ 
          headers:{"Authorization" :`Bearer ${localStorage.idToken}`
          }
             })
             .then(response => {
                 console.log(response)
                 this.user = response.user
                 this.image = response.image
             }) 
      }
             
    },
    setRating (rating) {
      this.rating = rating
    },
    closeModal () {
      this.isModalForm = false
    },
    ChangeForm(FormComponent) {
      console.log(FormComponent)
      this.FormComponent = FormComponent
    },
    LoginPop () {
      this.$buefy.toast.open({
              duration: 3000,
              message: '本棚登録するにはログインが必要です',
              type: 'is-info'
            })

    }
  }
 }
</script>


