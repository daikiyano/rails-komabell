<template>
  <div>
    <div style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 10px 20px; text-align: center;">
      <img :src="books.largeImageUrl" alt="TOP本"> 
        {{books.itemCaption}}  
        著者　{{books.author}}
        出版社　{{books.publisherName}}
    </div>
  </div>
</template>

<script>
 export default {
    data() {
      return {
        books : ""
      }
    },
    created () {
      this.test()
    },
  methods: {
    test () {
      const isbn = this.$route.params.id
       this.$axios.$get(`/api/v1/books/${isbn}`)
      .then(res => {
        console.log(res)
        console.log(res.data[0].params)
      this.books = res.data[0].params
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
    }
  }
 }
</script>


