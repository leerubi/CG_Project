using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MouseCursorScript : MonoBehaviour
{
    public Texture2D cursorTexture;


    public Texture2D cursorTexture1;


    public Texture2D cursorTexture2;





    public bool hotSpotIsCenter = false;
    public Vector2 adjustHotSpot = Vector2.zero;
    private Vector2 hotSpot;
    public void Start()
    {

        StartCoroutine("MyCursor");
    }
    IEnumerator MyCursor()
    {
        yield return new WaitForEndOfFrame();

        if (hotSpotIsCenter)
        {
            hotSpot.x = cursorTexture.width / 2;
            hotSpot.y = cursorTexture.height / 2;
        }
        else
        {
            hotSpot = adjustHotSpot;
        }
        Cursor.SetCursor(cursorTexture, hotSpot, CursorMode.Auto);
    }

    public void Update()
    {

        if (Input.GetMouseButtonUp(0) || Input.GetMouseButtonUp(1))
        {
            if (hotSpotIsCenter)
            {
                hotSpot.x = cursorTexture.width / 2;
                hotSpot.y = cursorTexture.height / 2;
            }
            else
            {
                hotSpot = adjustHotSpot;
            }
            Cursor.SetCursor(cursorTexture, hotSpot, CursorMode.Auto);
        }



        if (Input.GetMouseButtonDown(0))
        {
            if (hotSpotIsCenter)
            {
                hotSpot.x = cursorTexture1.width / 2;
                hotSpot.y = cursorTexture1.height / 2;
            }
            else
            {
                hotSpot = adjustHotSpot;
            }
            Cursor.SetCursor(cursorTexture1, hotSpot, CursorMode.Auto);
        }

        if (Input.GetMouseButtonDown(1))
        {
            if (hotSpotIsCenter)
            {
                hotSpot.x = cursorTexture2.width / 2;
                hotSpot.y = cursorTexture2.height / 2;
            }
            else
            {
                hotSpot = adjustHotSpot;
            }
            Cursor.SetCursor(cursorTexture2, hotSpot, CursorMode.Auto);
        }

    }
}
