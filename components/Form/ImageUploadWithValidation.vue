<template>
    <div>
        <div class="card-content">
            <section class="modal-card-body">
                <header class="modal-card-head">
                    <p class="modal-card-title">画像を設定する</p>
                    <input
                       accept="image/png,image/jpeg,image/gif" 
                        type="file"
                        name="file"
                        @change="croppie"
                    />
                </header>
         <!-- accept="image/png,image/jpeg,image/gif" -->
                <div v-if="this.step === 1">
                    <vue-croppie ref="croppieRef" 
                        :enableExif="false"
                        :enableResize="false"
                        :enableOrientation="true"
                        :showZoomer="true"
                        :boundary="{ width: 400, height: 400}" 
                        :viewport="{ width:380, height:380, 'type':'circle' }"
                    >
                    </vue-croppie>
                    <button class="button" type="is-dark" @click="crop">Crop</button>
                </div>
                <div v-if="this.step === 2" style="text-align: center;">
                    <figure class="image is-128x128">
                        <img class="is-rounded" :src="croppedImage">
                    </figure>
                </div>
                <footer class="modal-card-foot">
                    <button v-if="this.croppedImage !== null" class="button" type="button" @click="ChangeImage()">画像を更新する</button>
                    <button class="button" type="button" @click="close()">閉じる</button>
                </footer>
            </section>
        </div> 
    </div>
</template>


<script>

export default {
    name: 'ImageUploadWithValidation' , 
    data() {
        return {
            cropped : "",
            file : "",
            croppedImage: null,  
            step : 0
        }
    },
    methods: {
        croppie (e) {
            this.isModalForm = true
            this.FormComponent = "ImageUploadWithValidation"
            console.log(this.formComponent)
            var files = e.target.files || e.dataTransfer.files;
            if (!files.length) return;
            console.log(files[0].name.split(".")[1])
            var filetype = files[0].name.split(".")[1]
            if (filetype === "jpg" || filetype === "jpeg" || filetype === "png" || filetype === "gif"){
                this.step = 1
                var reader = new FileReader();
                reader.onload = e => {
                    this.$refs.croppieRef.bind({
                    url: e.target.result
                    });
                };
                reader.readAsDataURL(files[0]);
            } else {
                this.$buefy.toast.open({
                duration: 5000,
                message: '指定された拡張子（PNG/JPG/GIF）ではありません',
                type: 'is-success'
                })
                return;
            }
             
        },
        crop() {
            this.step = 2
            let self = this;
            let options = {
                type: 'base64',
                size: { width: 128, height: 128 },
                format: 'jpeg'
            };
            this.$refs.croppieRef.result(options, output => {
                this.croppedImage = output;
                console.log("croppedImage")
                console.log(this.croppedImage)
                this.$emit('ChangeImage',this.croppedImage)
            });
        },
        close () {
            this.$emit('isCloseModal', false)
        },
        ChangeImage () {
            this.$emit('UploadImage')
        },
    }
}

</script>
<style>
.modal-card-body {
    box-shadow: 0 2px 10px rgba(0,0,0,.15);
}
.modal-card-head {
    background-color: white;
    border-bottom: 1px solid white;
}

.modal-card-foot {
    background-color: white;
    border-top: 1px solid white;
}
</style>