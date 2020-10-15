
export default function({redirect}) {
    if (!localStorage.admin) {
     return redirect('/')
    }
  }