<template>
<div>
    <h1>aaa</h1>
    <div v-for="(book,index) in this.books" :key="index" style="box-shadow: 0 1px 16px 0 rgba(0, 0, 0, 0.15);　display: inline-block; margin: 20px 20px; text-align: center; position: relative;">
          
          <nuxt-link :to="{name:'books-id',params:{id:book.isbn}}">
          <img style="width: 170px; height: 220px;" :src="book.imageurl" alt="TOP本"> 
          </nuxt-link>  
          <span style="position: absolute; left: 0; bottom: -20px; "><b-button type="is-info" size="is-small" @click="isModalForm=true; FormComponent='Memo'; BookDetail=book">メモを追加</b-button></span>
          
        </div>
        <Modal :isModalForm="this.isModalForm" 
            :FormComponent="this.FormComponent"  
            :BookDetail="this.BookDetail"   
            @isCloseModal="closeModal" 
            @ChangeForm="ChangeForm($event)" 
            @UpdateMemo="UpdateMemo($event)" 
            aria-role
          />
         
      
     
</div>

</template>
<script>
    import Modal from '~/components/Modal.vue'
    import Memo from '~/components/BookShelf/Memo.vue'





export default {
    middleware: 'admin',
    components: {
       Modal,
       Memo
    },
    data() {
    return { 
       books : "",
       isModalForm : false,
       FormComponent : "",
       BookDetail : {}
    }
    
  },
  created () {
      this.FeachBookShelf()
  },
   
    methods: {
        
       FeachBookShelf () {
      this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
       this.$axios.$get('/api/v1/book/bookshelves')
      .then(res => {
        console.log(res)
        this.books = res.bookshelves
        

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
    closeModal () {
      this.isModalForm = false
    },
    ChangeForm(FormComponent) {
      console.log(FormComponent)
      this.FormComponent = FormComponent
    },
    UpdateMemo(Memo) {
      console.log(Memo[0])
      this.$axios.defaults.headers.common['Authorization'] = `Bearer ${localStorage.idToken}`    
            this.$axios.$patch('/api/v1/book/memos',{ 
                bookshelf : {
                    memo : Memo[0],
                    isbn : Memo[1]
                }
            })
            .then(response => {
                this.$buefy.toast.open({
                    duration: 1000,
                    message: '読書メモを更新しました',
                    type: 'is-success'
                })
                 console.log(response)
                 this.isModalForm = false
                 this.FeachBookShelf()
                //  this.$router.push('/users/bookshelf')
                
            })
            .catch ( error => {
                if (error.response.status == "401" || error.response.status == "500" || error.response.status == "422") {
                        // this.error = "Tokenが無効です"
                    this.$buefy.toast.open({
                        duration: 5000,
                        message: 'サーバー内で問題が発生しました',
                        type: 'is-danger'
                    })
                }
            })
    }
      
    }
}

</script>
