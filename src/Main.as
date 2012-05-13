package {
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   import flash.system.Capabilities;
   import flash.utils.getTimer;
   
   import com.tapirgames.gesture.GestureAnalyzer;
   import com.tapirgames.gesture.GesturePoint;
   import com.tapirgames.gesture.GestureSegment;
   
   public class Main extends Sprite
   {
      public function Main ()
      {
         addEventListener (Event.ADDED_TO_STAGE , OnAddedToStage);
         
         mBackground = new Sprite ();
         addChild (mBackground);
         
         mPointLayer = new Sprite ();
         addChild (mPointLayer);
         
         mLineLayer = new Sprite ();
         addChild (mLineLayer);
         
         mBackground.graphics.beginFill(0xD0D0FF);
         mBackground.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
         mBackground.graphics.endFill();
         
         mTextField = new TextField ();
         mTextField.autoSize = TextFieldAutoSize.LEFT;
         mTextField.background = true;
         mTextField.border = true;

         var format:TextFormat = new TextFormat();
         format.font = "Verdana";
         format.color = 0xFF0000;
         format.size = 10;
         format.underline = false;

         mTextField.defaultTextFormat = format;
         addChild(mTextField);
         
         SetText ("wait input ...");
      }
      
      private var mBackground:Sprite;
      
      private var mPointLayer:Sprite;
      private var mLineLayer:Sprite;
      
      private var mTextField:TextField;
      
      public function SetText (text:String):void
      {
         mTextField.text = text;
      }
      
      private function OnAddedToStage (event:Event):void 
      {
         stage.frameRate = 100;
         
         addEventListener (MouseEvent.MOUSE_DOWN, OnMouseDown);
         addEventListener (MouseEvent.MOUSE_MOVE, OnMouseMove);
         addEventListener (MouseEvent.MOUSE_UP, OnMouseUp);
      }
      
      private var mGestureAnalyzer:GestureAnalyzer = null;
      
      private function OnMouseDown (event:MouseEvent):void
      {
         mLineLayer.graphics.clear ();
         mPointLayer.graphics.clear ();
         
         if (mGestureAnalyzer == null)
            mGestureAnalyzer = new GestureAnalyzer (Capabilities.screenDPI * 0.2, Capabilities.screenDPI * 0.02);
         
         RegisterGesturePoint (mGestureAnalyzer, event.stageX, event.stageY);
      }
      
      private function OnMouseMove (event:MouseEvent):void
      {
         if (mGestureAnalyzer != null)
         {
            if (event.buttonDown)
            {
               RegisterGesturePoint (mGestureAnalyzer, event.stageX, event.stageY);
            }
            else
            {
               mGestureAnalyzer = null;
            }
         }
      }
      
      private function OnMouseUp (event:MouseEvent):void
      {
         if (mGestureAnalyzer != null)
         {
            RegisterGesturePoint (mGestureAnalyzer, event.stageX, event.stageY);

            var result:Object = mGestureAnalyzer.Analyze ();
            
            var infoString:String = "Result:";
            infoString = infoString + "\n-Num of points: " + result.mNumPoints;
            infoString = infoString + "\n-Type: " + result.mGestureType;
            infoString = infoString + "\n-Angle: " + result.mGestureAngle;
            infoString = infoString + "\n-Message: " + result.mAnalyzeMessage;
            
            SetText (infoString);
         }
         
         mGestureAnalyzer = null;
      }
      
      private function RegisterGesturePoint (gestureAnalyzer:GestureAnalyzer, pixelX:Number, pixelY:Number):void
      {  
         if (gestureAnalyzer == null)
            return;
         
         var inchX:Number = pixelX;
         var inchY:Number = pixelY;
         var gesturePoint:GesturePoint = gestureAnalyzer.RegisterPoint (inchX, inchY, getTimer ());
         if (gesturePoint != null)
         {
            mPointLayer.graphics.beginFill(0x00FF00);
            mPointLayer.graphics.drawCircle(pixelX, pixelY, 6);
            mPointLayer.graphics.endFill();
            
            if (gesturePoint.mPrevPoint != null)
            {
               var lastPixelX:Number = gesturePoint.mPrevPoint.mX;
               var lastPixelY:Number = gesturePoint.mPrevPoint.mY;
               mLineLayer.graphics.lineStyle(0, 0x000000);
               mLineLayer.graphics.moveTo(lastPixelX, lastPixelY);
               mLineLayer.graphics.lineTo(pixelX, pixelY);
            }
         }
      }
   }
}
