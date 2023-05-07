import { MessageBox, Message} from 'element-ui'

// 封装提示信息

export default function myConfirm(text){
  return new Promise((resolve, reject) => {
    MessageBox.confirm(text, '系统提示' ,{
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: "warning"
    }).then(() => {
      resolve(true)
    }).catch(() =>{
      reject(false)
    })
  }).catch(()=>{

  })
}
