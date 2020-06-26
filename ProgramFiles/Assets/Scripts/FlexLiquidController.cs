using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace NVIDIA.Flex
{

    public class FlexLiquidController : MonoBehaviour
    {
        public GameObject LiquidObject;
        public float timer = 5f;
        public bool isFirst = true;
        public bool isSecond = true;
        public float metalic = 0.4f;
        public float glossiness = 0.6f;
        

        // Start is called before the first frame update
        void Start()
        {

            if (isSecond)
            {
                gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Metallic", 0.4f);
                gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Glossiness", 0.6f);
            }
            else
            {
                gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Metallic", 0f);
                gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Glossiness", 0f);
            }


        }

        // Update is called once per frame
        void Update()
        {
            if (isFirst)       
            {
                if (GetComponent<MeshSplitting.Splitables.Splitable>().split)
                {
                    LiquidObject.GetComponent<FlexSourceActor>().isActive = true;
                    GetComponent<MeshSplitting.Splitables.Splitable>().split = false;

                    SoundManager.instance.PlaySE("waterSound");

                }


                if (LiquidObject.GetComponent<FlexSourceActor>().isActive)
                {
                    timer -= Time.deltaTime;
                    metalic -= Time.deltaTime * 0.2f;
                    glossiness -= Time.deltaTime * 0.2f;

                    if (metalic < 0f) metalic = 0f;
                    if (glossiness < 0f) glossiness = 0f;

                    if (timer < 0f)
                    {
                        LiquidObject.GetComponent<FlexSourceActor>().isActive = false;
                        timer = 5f;
                        isFirst = false;
                        
                    }

                    gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Metallic", metalic);
                    gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("_Glossiness", glossiness);

                }
            }
            else
            {
                if (isSecond)
                {
                    timer -= Time.deltaTime;
                    if (timer < 0f)
                    {
                        Destroy(LiquidObject);
                        isSecond = false;
                    }
                }

            }




        }



    }

   

}
