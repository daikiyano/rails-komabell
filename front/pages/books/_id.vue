<template>
  <div>
    <div style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 10px 20px; text-align: center;">
      <img :src="books.largeImageUrl" alt="TOP本"> 
        {{books.itemCaption}}  
        著者　{{books.author}}
        出版社　{{books.publisherName}}
        {{IsBookshelf}}
        
        <span v-if="IsBookshelf === false" style="position: absolute; left: 0; bottom: -20px; "><b-button type="is-info" size="is-small" @click="PostBookShelf(books.isbn,books.largeImageUrl)">本棚に登録</b-button></span>
        <span v-if="IsBookshelf === true" style="position: absolute; left: 0; bottom: -20px; "><b-button type="is-info" size="is-small">本棚から外す</b-button></span>


    </div>
  </div>
</template>

<script>
 export default {
    data() {
      return {
        books : "",
        IsBookshelf : null
      }
    },
    created () {
      this.test()
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


